function Write-IStreamToFile([__ComObject] $istream, [string] $fileName)
{
	# NOTE: We cannot use [System.Runtime.InteropServices.ComTypes.IStream],
	# since PowerShell apparently cannot convert an IStream COM object to this
	# Powershell type.  (See http://stackoverflow.com/a/9037299/223837 for
	# details.)
	# It turns out that .NET/CLR _can_ do this conversion.
	#
	# That is the reason why method FileUtil.WriteIStreamToFile(), below,
	# takes an object, and casts it to an IStream, instead of directly
	# taking an IStream inputStream argument.

 
	$cp = New-Object CodeDom.Compiler.CompilerParameters             
	$cp.CompilerOptions = "/unsafe"
	$cp.WarningLevel = 4
	$cp.TreatWarningsAsErrors = $true

	Add-Type -CompilerParameters $cp -TypeDefinition @"
		using System;
		using System.IO;
		using System.Runtime.InteropServices.ComTypes;

		namespace My
		{
			public static class FileUtil {
				public static void WriteIStreamToFile(object i, string fileName) {
					IStream inputStream = i as IStream;
					FileStream outputFileStream = File.OpenWrite(fileName);
					int bytesRead = 0;
					int offset = 0;
					byte[] data;
					do {
						data = Read(inputStream, 2048, out bytesRead);  
						outputFileStream.Write(data, 0, bytesRead);
						offset += bytesRead;
					} while (bytesRead == 2048);
					outputFileStream.Flush();
					outputFileStream.Close();
				}

				unsafe static private byte[] Read(IStream stream, int toRead, out int read) {
				    byte[] buffer = new byte[toRead];
				    int bytesRead = 0;
				    int* ptr = &bytesRead;
				    stream.Read(buffer, toRead, (IntPtr)ptr);   
				    read = bytesRead;
				    return buffer;
				} 
			}

		}
"@
 
	[My.FileUtil]::WriteIStreamToFile($istream, $fileName)
}
 
