local ffi = require("ffi")
local C = ffi.C 
local bit = require("bit")
local bor, band = bit.bor, bit.band

local blapi = require("blend2d_ffi")


local BLArray = ffi.typeof("struct BLArrayCore")

ffi.metatype(BLArray, {
    __gc = function(self)
        blapi.blArrayReset(self);
    end;

    __new = function(ct, arrayTypeId)
        arrayTypeId = arrayTypeId or 0
        local obj = ffi.new(ct);
        blapi.blArrayInit(obj,arrayTypeId)

        return obj;
    end;

    __index = {
        -- Attributes
        getCapacity = function(self)
            return blapi.blArrayGetCapacity(self)
        end;

        getSize = function(self)
            return blapi.blArrayGetSize(self);
        end;

        -- Actions
        clear = function(self)
            local bResult = blapi.blArrayClear(self)
            if bResult == C.BL_SUCCESS then
                return true;
            end

            return false, bResult;
        end;

        shrink = function(self)
            local bResult = blapi.blArrayShrink(self)
            if bResult == C.BL_SUCCESS then
                return true;
            end

            return false, bResult;
        end;

        getData = function(self)
            return blapi.blArrayGetData(self)
        end;

        reserve = function(self, size)
            local bResult = blapi.blArrayReserve(self, size)
            if bResult == C.BL_SUCCESS then
                return true;
            end

            return false, bResult;
        end;

        resize = function(self, size, data)
            local bResult = blapi.blArrayResize(self, size, fill)
            if bResult == C.BL_SUCCESS then
                return true;
            end

            return false, bResult;
        end;

        makeMutable = function(self)
            local outdata = ffi.new("void *[1]")
            local bResult = blapi.blArrayMakeMutable(self, outdata)
            if bResult == C.BL_SUCCESS then
                return outdata[0];
            end

            return false, bResult;
        end;

        -- Adding items
        appendU8 = function(self, value)
            blapi.blArrayAppendU8(self, value)
        end;

        appendU16 = function(self, value)
            blapi.blArrayAppendU16(self, value)
        end;

        appendU32 = function(self, value)
            blapi.blArrayAppendU32(self, value)
        end;

        appendU64 = function(self, value)
            blapi.blArrayAppendU64(self, value)
        end;

        appendF32 = function(self, value)
            blapi.blArrayAppendF32(self, value)
        end;

        appendF64 = function(self, value)
            blapi.blArrayAppendF64(self, value)
        end;

        appendItem = function(self, item)
            blapi.blArrayAppendItem(self, item)
        end;

        appendView = function(self, items, size)
            blapi.blArrayAppendView(self, items, size)
        end;

        -- Insert
        insert = function(self, idx, item)
        end;

        replace = function(self, idx, item)
        end;
    }

})
return BLArray