/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200110 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ACPI/SSDT-GPI0.aml, Wed Jun  3 10:10:39 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000055 (85)
 *     Revision         0x02
 *     Checksum         0x87
 *     OEM ID           "ARCH"
 *     OEM Table ID     "GPI0"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200110 (538968336)
 */
DefinitionBlock ("", "SSDT", 2, "ARCH", "GPI0", 0x00000000)
{
    External (GPEN, FieldUnitObj)
    External (SBRG, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            GPEN = One
            SBRG = One
        }
    }
}

