package Test_Interface is

    procedure Test_Main
        with Global => null,
             Export => True,
             Convention => C,
             External_Name => "test_main";

end Test_Interface;
