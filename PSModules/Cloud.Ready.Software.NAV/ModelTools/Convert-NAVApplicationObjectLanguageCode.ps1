function Convert-NAVApplicationObjectLanguageCode{
    param(
        [String] $Convert
    )
    
    $Languages = @{
        '1033'='ENU';
        ENU='1033';

        '2067'='NLB';
        NLB = '2067';

        '1030' = 'DAN';
        DAN = '1030';

        '3079' = 'DEA';
        DEA = '3079';

        '2055' = 'DES';
        DES = '2055';

        '1031' = 'DEU';
        DEU = '1031';

        '4105' = 'ENC';
        ENC = '4105';

        '2058' = 'ESM';
        ESM = '2058';

        '1034' = 'ESP';
        ESP = '1034';

        '1036' = 'FRA';
        FRA = '1036';

        '2060' = 'FRB';
        FRB = '2060';

        '3084' = 'FRC';
        FRC = '3084';

        '1040' = 'ITA';
        ITA = '1040';

        '1043' = 'NLD';
        NLD = '1043';

        '2070' = 'PTG';
        PTG = '2070';

        '1053' = 'SVE';
        SVE = '1053';

    }

    if ([string]::IsNullOrEmpty($Languages.$Convert)){
        return $Convert
    } else {
        return $Languages.$Convert
    }
}