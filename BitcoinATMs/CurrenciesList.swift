//
//  CurrenciesList.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 3/7/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit

struct BitMapItem {
    let type: String
    let latitude: NSDecimalNumber
    let longitude: NSDecimalNumber
    let url: String
    let is_two_way: Bool
    let bit_types: NSDictionary
    
    init (type: String, latitude: NSDecimalNumber, longitude: NSDecimalNumber, url: String, isTwoWay: Bool, bitTypes: NSDictionary) {
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
        self.is_two_way = isTwoWay
        self.bit_types = bitTypes
    }
}

let url = NSURL(string: "https://api.bitcoinaverage.com/ticker/global/")
let map_url = NSURL(string: "http://coinatmradar.com/api/locations/2011-02-10/")!

//AED 0
//AFN 1
//ALL 2
//AMD 3
//ANG 4
//AOA 5
//ARS 6
//AUD 7
//AWG 8
//AZN 9
//BAM 10
//BBD 11
//BDT 12
//BGN 13
//BHD 14
//BIF 15
//BMD 16
//BND 17
//BOB 18
//BRL 19
//BSD 20
//BTN 21
//BWP 22
//BYR 23
//BZD 24
//CAD 25
//CDF 26
//CHF 27
//CLF 28
//CLP 29
//CNY 30
//COP 31
//CRC 32
//CUC 33
//CUP 34
//CVE 35
//CZK 36
//DJF 37
//DKK 38
//DOP 39
//DZD 40
//EEK 41
//EGP 42
//ERN 43
//ETB 44
//EUR 45
//FJD 46
//FKP 47
//GBP 48
//GEL 49
//GGP 50
//GHS 51
//GIP 52
//GMD 53
//GNF 54
//GTQ 55
//GYD 56
//HKD 57
//HNL 58
//HRK 59
//HTG 60
//HUF 61
//IDR 62
//ILS 63
//IMP 64
//INR 65
//IQD 66
//IRR 67
//ISK 68
//JEP 69
//JMD 70
//JOD 71
//JPY 72
//KES 73
//KGS 74
//KHR 75
//KMF 76
//KPW 77
//KRW 78
//KWD 79
//KYD 80
//KZT 81
//LAK 82
//LBP 83
//LKR 84
//LRD 85
//LSL 86
//LTL 87
//LVL 88
//LYD 89
//MAD 90
//MDL 91
//MGA 92
//MKD 93
//MMK 94
//MNT 95
//MOP 96
//MRO 97
//MTL 98
//MUR 99
//MVR 100
//MWK 101
//MXN 102
//MYR 103
//MZN 104
//NAD 105
//NGN 106
//NIO 107
//NOK 108
//NPR 109
//NZD 110
//OMR 111
//PAB 112
//PEN 113
//PGK 114
//PHP 115
//PKR 116
//PLN 117
//PYG 118
//QAR 119
//RON 120
//RSD 121
//RUB 122
//RWF 123
//SAR 124
//SBD 125
//SCR 126
//SDG 127
//SEK 128
//SGD 129
//SHP 130
//SLL 131
//SOS 132
//SRD 133
//STD 134
//SVC 135
//SYP 136
//SZL 137
//THB 138
//TJS 139
//TMT 140
//TND 141
//TOP 142
//TRY 143
//TTD 144
//TWD 145
//TZS 146
//UAH 147
//UGX 148
//USD 149
//UYU 150
//UZS 151
//VEF 152
//VND 153
//VUV 154
//WST 155
//XAF 156
//XAG 157
//XAU 158
//XCD 159
//XDR 160
//XOF 161
//XPF 162
//YER 163
//ZAR 164
//ZMK 165
//ZMW 166
//ZWL 167

let HEIGHT = 1/246.0 as CGFloat
let WIDTH = 1.0 as CGFloat
let X_VALUE = 0 as CGFloat

func rectForFlag(#value: Int) -> CGRect {
    return CGRectMake(0, flagPositionWith(value: Double(value)), WIDTH, HEIGHT)
}

func flagPositionWith(#value: Double) -> (CGFloat) {
    return CGFloat((1 * 32.0 * value) / (246 * 32.0))
}


let currencies: [String] = [
    "AED", //23
    "AFN",//24
    "ALL",//26
    "AMD",//28
    "ANG",//--
    "AOA",//29
    "ARS",//31
    "AUD",//34
    "AWG",//35
    "AZN",//37
    "BAM",//38
    "BBD",//39
    "BDT",//40
    "BGN",//41
    "BHD",//44
    "BIF",//45
    "BMD",//47
    "BND",//48
    "BOB",//49
    "BRL",//50
    "BSD",//51
    "BTN",//52
    "BWP",//53
    "BYR",//54
    "BZD",//55
    "CAD",//56
    "CDF",//57
    "CHF",//60
    "CLF",//63=
    "CLP",//63
    "CNY",//65
    "COP",//66
    "CRC",//67
    "CUC",//68=
    "CUP",//68
    "CVE",//69
    "CZK",//71
    "DJF",//73
    "DKK",//74
    "DOP",//76
    "DZD",//77
    "EEK",//79
    "EGP",//80
    "ERN",//82
    "ETB",//84
    "EUR",//8/////////
    "FJD",//86
    "FKP",//86-=
    "GBP",//91
    "GEL",//93
    "GGP",//94
    "GHS",//95
    "GIP",//96
    "GMD",//98
    "GNF",//101
    "GTQ",//105
    "GYD",//108
    "HKD",//109
    "HNL",//110
    "HRK",//111
    "HTG",//112
    "HUF",//113
    "IDR",//114
    "ILS",//116
    "IMP",//117
    "INR",//118
    "IQD",//119
    "IRR",//120
    "ISK",//121
    "JEP",//123
    "JMD",//124
    "JOD",//125
    "JPY",//126
    "KES",//127
    "KGS",//128
    "KHR",//129
    "KMF",//131
    "KPW",//133
    "KRW",//134
    "KWD",//135
    "KYD",//136
    "KZT",//137
    "LAK",//138
    "LBP",//139
    "LKR",//142
    "LRD",//143
    "LSL",//144
    "LTL",//145
    "LVL",//147
    "LYD",//148
    "MAD",//149
    "MDL",//150
    
    "MGA",//152
    "MKD",//154
    "MMK",//156
    "MNT",//157
    "MOP",//158///
    "MRO",//160
    "MTL",//162
    "MUR",//163
    "MVR",//164
    "MWK",//165
    "MXN",//166
    "MYR",//167
    "MZN",//168
    "NAD",//169
    "NGN",//172
    "NIO",//173
    "NOK",//175
    "NPR",//176
    "NZD",//178
    "OMR",//179
    "PAB",//180
    "PEN",//181
    "PGK",//183
    "PHP",//184
    "PKR",//185
    "PLN",//186
    "PYG",//191
    "QAR",//192
    "RON",//194
    "RSD",//195
    "RUB",//196
    "RWF",//197
    "SAR",//198
    "SBD",//199
    "SCR",//200
    "SDG",//201
    "SEK",//202
    "SGD",//203
    "SHP",//215
    
    "SLL",//206
    "SOS",//209
    "SRD",//210
    "STD",//211
    "SVC",//212
    "SYP",//213
    
    "SZL",//214
    "THB",//218
    "TJS",//219
    "TMT",//221
    "TND",//222
    "TOP",//223
    "TRY",//224
    
    
    "TTD",//225
    "TWD",//226
    "TZS",//227
    "UAH",//228
    "UGX",//229
    "USD",//230
    "UYU",//231
    
    
    "UZS",//232
    "VEF",//233
    "VND",//234
    "VUV",//235
    "WST",//236
    "XAF",//237
    "XAG",//238
    "XAU",//239
    "XCD",//240
    "XDR",//241
    "XOF",//242
    "XPF",//243
    "YER",//244
    "ZAR",//245
    "ZMK",//246
    "ZMW",//247
    "ZWL"//248
]

let symbols: [String] = [
    "\u{62f}\u{2e}\u{625}",
    "\u{60b}",
    "\u{4c}\u{65}\u{6b}",
    "\u{058F}",//AMD
    "\u{192}",
    "Kz",
    "\u{24}",
    "\u{24}",
    "\u{192}",
    "\u{43c}\u{430}\u{43d}",
    "\u{4d}\u{4d}",
    "\u{24}",
    "৳",
    "\u{43b}\u{432}",
    "BHD",
    "BIF",
    "\u{24}",
    "\u{24}",
    "\u{24}\u{62}",
    "\u{52}\u{24}",
    "$",
    "BTN",
    "\u{50}",
    "BYR",
    "\u{42}\u{5a}\u{24}",
    "\u{24}",
    "CDF",
    "\u{43}\u{48}\u{46}",
    "CLF",
    "\u{24}",
    "\u{a5}",
    "\u{24}",
    "\u{20a1}",
    "CUC",
    "\u{20b1}",
    "CVE",
    "\u{4b}\u{10d}",
    "DJF",
    "\u{6b}\u{72}",
    "\u{52}\u{44}\u{24}",
    "DZD",
    "\u{6b}\u{72}",
    "\u{a3}",
    "ERN",
    "ETB",
    "\u{20ac}",
    "\u{24}",
    "\u{a3}",
    "\u{a3}",
    "GEL",
    "\u{a3}",
    "\u{47}\u{48}\u{20b5}",
    "\u{a3}",
    "GMD",
    "GNF",
    "\u{51}",
    "\u{24}",
    "\u{24}",
    "\u{4c}",
    "\u{6b}\u{6e}",
    "HTG",
    "\u{46}\u{74}",
    "\u{52}\u{70}",
    "\u{20aa}",
    "\u{a3}",
    "\u{20b9}",
    "IQD",
    "\u{fdfc}",
    "\u{6b}\u{72}",
    "\u{a3}",
    "\u{4a}\u{24}",
    "JOD",
    "\u{a5}",
    "KES",
    "\u{43b}\u{432}",
    "\u{17db}",
    "KMF",
    "\u{20a9}",
    "\u{20a9}",
    "KWD",
    "\u{24}",
    "\u{43b}\u{432}",
    "\u{20ad}",
    "\u{a3}",
    "\u{20a8}",
    "\u{24}",
    "LSL",
    "\u{4c}\u{74}",
    "\u{4c}\u{73}",
    "LYD",
    "\u{2e}\u{62f}\u{2e}\u{645}",
    "MDL",
    "MGA",
    "\u{434}\u{435}\u{43d}",
    "\u{4b}",
    "\u{20ae}",
    "MOP",
    "MRO",
    "MTL",
    "\u{20a8}",
    "MVR",
    "MWK",
    "\u{24}",
    "\u{52}\u{4d}",
    "\u{4d}\u{54}",
    "\u{24}",
    "\u{20a6}",
    "\u{43}\u{24}",
    "\u{6b}\u{72}",
    "\u{20a8}",
    "\u{24}",
    "\u{fdfc}",
    "\u{42}\u{2f}\u{2e}",
    "\u{53}\u{2f}\u{2e}",
    "PGK",
    "\u{20b1}",
    "\u{20a8}",
    "\u{7a}\u{142}",
    "\u{47}\u{73}",
    "\u{fdfc}",
    "\u{6c}\u{65}\u{69}",
    "RSD",
    "₽",
    "RWF",
    "\u{fdfc}",
    "\u{24}",
    "SCR",
    "SDG",
    "\u{6b}\u{72}",
    "\u{24}",
    "\u{a3}",
    "SLL",
    "\u{53}",
    "\u{24}",
    "STD",
    "\u{24}",
    "\u{a3}",
    "SZL",
    "\u{e3f}",
    "TJS",
    "TMT",
    "TD",
    "TOP",
    "\u{20ba}",
    "\u{54}\u{54}\u{24}",
    "\u{4e}\u{54}\u{24}",
    "TZS",
    "\u{20b4}",
    "UGX",
    "\u{24}",
    "\u{24}\u{55}",
    "\u{43b}\u{432}",
    "\u{42}\u{73}",
    "\u{20ab}",
    "VUV",
    "WST",
    "FCFA",
    "XAG",
    "XAU",
    "\u{24}",
    "XDR",
    "XOF",
    "F",
    "fdfc",
    "\u{52}",
    "ZMK",
    "ZMW",
    "ZWL"
]

let flags_: [Int] = [
    22,
    23,
    26,
    27,
    300,
    28,
    30,
    33,
    34,
    36,
    37,
    38,
    39,
    42,
    43,
    44,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    59,
    62,
    62,
    64,
    65,
    66,
    67,
    67,
    68,
    70,
    72,
    73,
    75,//dop
    76,//dzd
    78,//eek
    79,//egp
    81,//ern
    83,
    7,
    85,
    85,
    90,
    92,
    93,
    94,
    95,
    96,
    100,
    102,//gtq
    105,//
    106,
    107,
    108,
    109,
    110,
    111,//
    113,//ils
    114,
    115,
    116,
    117,
    118,//
    120,//jep
    121,
    122,
    123,
    124,
    125,
    126,//khr
    128,//kmf
    130,
    131,//krw
    132,
    133,
    134,
    135,
    136,//lbp
    139,
    140,
    141,
    142,
    143,
    144,
    146,
    147,//mdl
    149,//mga
    152,
    153,
    154,
    155,
    157,//mro
    159,
    160,
    161,
    162,
    163,
    164,
    165,
    166,
    169,//ngn
    170,//nio
    172,//nok
    173,
    174,
    176,
    177,
    179,
    180,//pgk
    181,//php
    182,
    183,
    188,
    189,
    191,//ron
    192,
    193,
    194,
    195,
    196,
    197,
    198,
    199,
    200,
    212,//
    203,
    206,//sos
    207,
    208,
    209,
    210,
    211,
    212,
    213,
    214,
    219,
    222,
    221,//try
    222,
    223,
    224,
    225,
    226,
    228, //usd
    230,
    231,
    232,
    236,
    233,
    234,
    235,
    237,
    238,
    239,
    240,
    241,
    242,
    246,
    226,
    241,
    241,
    242,
]
