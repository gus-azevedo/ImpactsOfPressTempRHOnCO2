%% Run-time configuration for each experiment
classdef Constants
    %% CONSTANTS
    properties (Constant)
        %Global
        FILE_TYPE = ".csv";
        SYSTEM_SEPARATOR = "\";
        REF_IN = "Reference";
        PRES = 'P';
        TEMP = 'T';
        RH = 'U';
        T_RH ='R';
        MESONET = 'M';
        BENCH = 'B';
        OFFSET_820 = 17.7326;
        REF_PRES = 101300;
        REF_TEMP = 15;
        REF_RH = 36; % For Dew Point (T) = 0º at 15º Celsius (air temp)
    end
        methods(Static)
        function offset = getOffset(id)
            if id == Config.REF_OUT
                offset = 17.7326;
                return;
            end
            if id == Config.REF_IN
                offset = 0;
                return;
            end
            if contains(id, Config.TEST_00)
                if contains(id, "1")
                    offset = 0;
                    return
                end
                if contains(id, "2")
                    offset = 0;
                    return
                end
                if contains(id, "3")
                    offset = -8.580432857457033;
                    return
                end
                if contains(id, "4")
                    offset = -19.758326521271936;
                    return
                end
                disp("ERROR OFFSET T_00");
            end
            if contains(id, Config.TEST_20)
                if contains(id, "1")
                    offset = 58.831259547285086;
                    return
                end
                if contains(id, "2")
                    offset = 0.219814377632736;
                    return
                end
                disp("ERROR OFFSET T_20");
            end
            if contains(id, Config.TEST_25)
                if contains(id, "1")
                    offset = -42.4404216467;
                    return
                end
                if contains(id, "2")
                    offset = 44.8244018394;
                    return
                end
                disp("ERROR OFFSET T_25");
            end
            disp("ERROR OFFSET");
        end
    end
end
