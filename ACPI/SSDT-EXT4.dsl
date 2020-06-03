/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200110 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ACPI/SSDT-EXT4.aml, Wed Jun  3 10:10:39 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000A3 (163)
 *     Revision         0x02
 *     Checksum         0x67
 *     OEM ID           "ARCH"
 *     OEM Table ID     "EXT4"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200110 (538968336)
 */
DefinitionBlock ("", "SSDT", 2, "ARCH", "EXT4", 0x00000000)
{
    External (_SB_.LID0, DeviceObj)
    External (_SB_.PCI0.LPCB.LID0, DeviceObj)

    Method (EXT4, 1, NotSerialized)
    {
        If ((0x03 == Arg0))
        {
            If (CondRefOf (\_SB.LID0))
            {
                Notify (\_SB.LID0, 0x80) // Status Change
            }

            If (CondRefOf (\_SB.PCI0.LPCB.LID0))
            {
                Notify (\_SB.PCI0.LPCB.LID0, 0x80) // Status Change
            }
        }
    }
}

