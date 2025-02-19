Return-Path: <kernel-hardening-return-21946-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id E6EE3C021AA
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2025 06:45:34 +0000 (UTC)
Received: (qmail 22235 invoked by uid 550); 19 Feb 2025 06:45:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22200 invoked from network); 19 Feb 2025 06:45:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739947524; x=1771483524;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=59xwsmRloR9mHyui7n1BBjHHPZS5QzSdslFlX+Q/Ehw=;
  b=PZbTGWTy/MorAS3MQ8qd4TdKiOGa31lFbsJQriufMothfqjGPw6ckhxI
   him0gWDbrc0MQDMr7ebe+QUb+HzjkB7Cs1LEnvsxv54je1vsrpwxHhNI6
   VHU5ytEfHW83EgZlk3sJjle8ji1F8mpld6quSaMEnZFcIugGsVNWoRFYE
   JgEGRuoNg5dnSXS30kX7UMhMLlkJuPJka2n7/5Ne7gs0tUFayjOFrY61n
   dZ2+Og9/tySsDjkRa6T7avk1h6agob6UueAVmJF/i1fe0yefkqyz8sFaY
   X/XcSJB5HeuepaXcs7vBnAf39+cmreXvL3ZUzxDP99Ut3nNjitPERowP5
   g==;
X-CSE-ConnectionGUID: CrL1ffaSRNi+EEmVptt5Mg==
X-CSE-MsgGUID: yD2DnyTYTLSg29UAuZpC2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="51290069"
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="51290069"
X-CSE-ConnectionGUID: eKDU+n4uTleza6sgFwTdEg==
X-CSE-MsgGUID: jD/j/GTGQP+DVU/26ZlozQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="114366759"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISUYbDy6HdNLwBgGO48eP3OQh7Y6sBNKXUp1cDwZkQZJEDxm2MzwM13vRHp0VsOBwDdPOcOYrvf18ilk2VAnS72WcaCr0z2OOfxdMvsAHM2D75JlrbVYTpLsFhqXJXj+2CqOqve4tka/ToojRZrGry7z1byxmJ19ctRkWER8If9+D7IimLlM9euUZjJe4mfDTDqpjb2zZVxZIW1IxDtHMG1KojMWmKSeZxMx0mShDLfdH7Gn7nbpK2mkkWQrIYTkMl1lFbjLs0PrkEHdlF7/PBWDLX6DZxoWYCpvNRgo5EYh12fePZgZa7Xts6muDSUU+WFN6dPa8VTJkv/Zz2zkAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59xwsmRloR9mHyui7n1BBjHHPZS5QzSdslFlX+Q/Ehw=;
 b=ZDbZyEs/AHqmhiwdIhM8us/MsuTrMCPD4OrzSMBr3gV71A9Uo0pxLwwj3SeDL8uydeP57gKtosM0Vt78vPAAEqifKFROivLlwyokzEo6qgAAhCwunHfZFTurq5AXXIllx0HVMqCFm8g6WLKfpcJabYasZxgU5L8ynAuEXKFeCo15nu/ZQLYDcavI1YGYwwHKVoB/iaY5ztyepvNgMmAIClbnGBVRPLySX68o0miE7vhEpqwZKPTBpyvg2W8PoZxHiY1kbhNTThLwivqUoBmgbjFiFrAdpkMcYy/zxcL3NJKG75uvEqtXYMs9VYwI39Pvkxb8TqHyWYbn3EEcvQm1xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "lwn@lwn.net" <lwn@lwn.net>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
CC: Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>
Subject: [Announce] Linux Security Summit Europe 2025 CfP
Thread-Topic: [Announce] Linux Security Summit Europe 2025 CfP
Thread-Index: AQHbgpm9kxc6rHevL0K4xEEJypCSVg==
Date: Wed, 19 Feb 2025 06:44:35 +0000
Message-ID: <DM8PR11MB5750B6E571BC84EF44ED884BE7C52@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <35b17495-427f-549f-6e46-619c56545b34@namei.org>
In-Reply-To: <35b17495-427f-549f-6e46-619c56545b34@namei.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|SA2PR11MB5067:EE_
x-ms-office365-filtering-correlation-id: 8d629ce6-5af5-4911-d78a-08dd50b0df8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bDhBNFFEbjN1NlVyRVdQNktXS1ozQW55VXUrRkpoNVEvUVlMQmhud2VaQUlN?=
 =?utf-8?B?MXFXaHlobDI2eUNRQjJ5T1JsaW5oV3ZpVVRMYWJONmxnOVpnQXh3WmtyTVhr?=
 =?utf-8?B?RTBJamQwYkNXc1RicGllblNOZDcxRFM4RDBsTThKWS9QbGgzb0FFK1NETGIv?=
 =?utf-8?B?ZzNjREpSZFkvTGo2U2diSzAwUUZRSjBpWThrOEprSXMxb2RPZUJacmI2aTBo?=
 =?utf-8?B?WEpGODNSczFHZHBNbEVGTE5FSjJXK1MxTDNRWFcwaGkzbFB6MlZUVEw1SjVJ?=
 =?utf-8?B?V05IVnpKQjhURTEwMXJYbEdoYThQd0JPc0U4TUZ4YUxmOVliRUlXdXQzdGJh?=
 =?utf-8?B?aDNCdmhtR3JyNWdhNTlyV1UxZWNRcEtVb0p5U0hPMjhhMnZrM251TGN3T25p?=
 =?utf-8?B?K3lMZ0hQQ21FeGZ0VzlJNG1RT0E2d1BjSmZaQk04T2VKL0RLU2tZeTBad2Zm?=
 =?utf-8?B?Rk4xUmIvVmxDak4ySWY1Y1dPNFRxSUFpVE8wbVl2TnA0ZHMySzhyMXdpaWww?=
 =?utf-8?B?UVdnY3QrVHVWSUpUb05lL2crZVE1VStkK1gyamZIVi9EdnVOcXAzQzBFNnY2?=
 =?utf-8?B?UkZ3ci9nb0tkT3NpREczWHlnN3Z0clRRc2o4by9DQ2hibGIrMXdOeHA2UmhV?=
 =?utf-8?B?bXQyS0UzYUV6Q3orNld2OGJqZ1l5M3FIMFR4OVFTWlFUckRmRHF0WUo4VE9o?=
 =?utf-8?B?N041RXorVzlPOTVJbTM3SE5keWlCdWF3QTIxQThOSmZsOUJuNDlIV0pFNXRh?=
 =?utf-8?B?M2hleEhOWnM1eEEwNUc1K0RWSk92WUw2SnIxYjF1b3NNZ2xPYlUxN0JUTFBG?=
 =?utf-8?B?WDhvcU5kUFNqSUJ4ZmVPeDNCRHZuNU02ajMrUG1Wb2FZbVYrcTQ4OUdmN1hw?=
 =?utf-8?B?T3Y0VnVST0dJSlhsWmJTQnBWbE0welJLREF5WmhpaDkweU1LbHoxbVRuY1Z6?=
 =?utf-8?B?WDhvcllrY0ZWWFNJNHNja3p4ZWN4cTlISTA4byttdWpmZ2tjdmlWY3czemZk?=
 =?utf-8?B?ZWU0ZHEycjVMb2RUUUtqTzBwZ21wMkp1LzhmZExZQ0lZbTRYZ0hZRzlyWlBv?=
 =?utf-8?B?RkRVbHhWcHB6aCtiQ2ZIOFIrWXRuejY2cXJRdld4RXprS3oyNFlNekJXVkNI?=
 =?utf-8?B?WkN1VWpsS3c4RHY3MTFQMDRzV2Y2cDlNaXo0MUZCYjcyVnU5RStYaDZuejBQ?=
 =?utf-8?B?WElPUENiM0ZCcHhPQ2d0SlZFL3NIQ2hpczlEeXljazdEQnhscVFQM25Xenht?=
 =?utf-8?B?NWtCaWc2cndtZFFBa0R4ZEJGUjhvRis4R1ZiQ0tsSTlOUldZdUpkTm9LRlln?=
 =?utf-8?B?a0dsRmw4QkVsQkl6U2F0cHpMdWxXNjk3QUNXREZyeTEyMEtWMm0yNmlCVy9h?=
 =?utf-8?B?aXZrRzRVd2ZwQ0VPeUxGdmVERUV1Mk8vYlVISHlJN29UdnYwTzRVZWRIREtD?=
 =?utf-8?B?ME5wMGVSMCtYdmlwMFgvcjJHNVM1dlJvbGZvYjZaWklFNmZNTSt5Y1kzYThw?=
 =?utf-8?B?UmVtZ1Q5SW45WmRMNncySFNlc2U0UzNtU2ZReDlxZHVUVEY1OWsrTlVRMmRq?=
 =?utf-8?B?UFJzTlRNWHlpOEZLVzkzVnhJNzEyaGh2ZldRYnVNWDJlTjZ2VzdkN2thQml5?=
 =?utf-8?B?MlNlb0htbCtSb3ZlNzFYd2greGFwZVJidkRmWTdQRllMemJENkZFeE42YlRk?=
 =?utf-8?B?T3J0VVZ2UXhiUWppMDNMY3gySWhvdEM3dVZsOWlnZS9IUHU3QThWUy91QUw0?=
 =?utf-8?B?bFRESmFEM3o1dnJEcTErTzQ1ejFtdXJMUEFyNDdCQ1JYa29ENDYxNmE4UGc2?=
 =?utf-8?B?bytVRUdFWElzamdub1AvTi9mZHJDZngrYzV5WUk0WDFFaWVGYUxWWC8wZ1J0?=
 =?utf-8?Q?LJHei3PuaAsyd?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVFNR0lRdU1YZ1FEazQxZmdBR3ZranBELzJ1aFUvSjZ4ZlJrd3F0UlRDVHla?=
 =?utf-8?B?YkVaWnNEV1ZpeERkYVBZUTJHTkQyWjFyTzhQbzBQSlhKc2wwbSt5OTNzbkJY?=
 =?utf-8?B?bk9sRXRGOUVzcXdUY05UOWg0S0hacnExZ3F2VmYwRTZoRDFtU1UrS3lYT3NM?=
 =?utf-8?B?cU1MM1I4Ti9mOFBQNTh4RUFqN2pKWnhwZ2xsTmdUdW15YmZ4a2NjN0xKcVpp?=
 =?utf-8?B?b3lsd1pSTHRVS0xmbDlqa0ZSaWRMU21XNlk0aEI4amJrb3RyTCtBK2RXdDNE?=
 =?utf-8?B?aEhOTGNJcnVEam9oQ1FLVjdoTUFaUFplLzRBWDAyWGJCQzViY0o4a1RvRjBU?=
 =?utf-8?B?c2ZFZHl6V3VYNVJobmtsT0tzOUhSc0dodjZ5NGNWVHFEb3FNeG9oRDc0c3RZ?=
 =?utf-8?B?UFRKeFNsVFhyRHB6NzY5TDR1dDd3SWJ1aDFOOEF5aWYrdGlhV1RzQ3JRM3hH?=
 =?utf-8?B?VU9pY21XandjN2pYNXpvaXR2K2k1V1RsSzBPckdaNXJWYW91L0pKci9kenBB?=
 =?utf-8?B?UVBFRG80VURteFFPS09FdUNhcHI3UHBzQ1ZDWGlKTzl3dXhRbUF6YjJMYzF4?=
 =?utf-8?B?NzBTcnozU3BsNjRrdW1OY3k3NUdIU0pTZmJ1aEJvenVSUkpSUzE0a3NkMCs4?=
 =?utf-8?B?cTVBMER6bWVyTFNTNWJ4dVpBR2toOGh0NHZDVTRCMmRHOG56ZUw1Z2tuS0ln?=
 =?utf-8?B?OC92Q0k2cnJrME9DY2Vab2RSY3ZMYjN0ZkxKVXFGTW43YnFUMkwvSkRnd2lM?=
 =?utf-8?B?QWN0bXJFekRIbWtqMmU5MWVoWGczMnJVUU5VaXlyN2dLTHdvZDNtbVFvZ3Jh?=
 =?utf-8?B?Nnp0L1lzcXBEYVRwKzR5T0NvYXRGYW4rc3JqZ3c5UVhEMFhqSjRaVDI5MTBi?=
 =?utf-8?B?aVJPcUtneTJmK3d6QmVVcVlRYXdVWGVKTERHVC9DUjJlV3lSb2xYM05JQmdk?=
 =?utf-8?B?NVJMb1JtM1JxbzZNLzVmcHRTTUdSa09Hd20rYUp1MCtWU3NBOTRNTCtHSUFw?=
 =?utf-8?B?eHVPb3F4MEs4SUNlUVVKWEwwdThFUC82Y243QmIzNVcrQ3E5L3Vubyt3WVhn?=
 =?utf-8?B?M0lCSlVNa2hqT05HZ1ZJZDFQREpqODhKd0wrM0wwazByTnE5bFJ5bzJBQ2RC?=
 =?utf-8?B?RUh5c1VpSkpwNVFsb3hyQitVbXpjRC83RHBnc3dveWRVMVBRdlFYTVhIa3V4?=
 =?utf-8?B?bkgreXF6dldXbm9IQ3EwMkJxdTZZZEk1V1l2eTVteWttSzJQYk92eXVhUlhy?=
 =?utf-8?B?ZXQ4OTBxazZSalZLWW55R0M4YTlxWmFHYmxCZlFwc2c0STVhdmFMd2IrV2Jx?=
 =?utf-8?B?anNlNXlTN3pKV1RxQ2pkWEcyemZvQmwxMWl4ektEMFkyYTV5YzVJb1lDSTVJ?=
 =?utf-8?B?RmxHTk8zTXdINkIyYVFLb055V2w4N3pNem5OL3plaU5YZlZ3aW02QjN2d0d0?=
 =?utf-8?B?Ry9VY0s1TytYV3hIdlA4ZWozQnJhckVZT01uQTg5Y1ZoZkU0Tm1rRGh3czVi?=
 =?utf-8?B?Tks0dC9vcHljeTdpT0QveUQrUWlpbTM5NzVaNkE5NytwRVAyOWlwc2hVRGJx?=
 =?utf-8?B?SEhpSDY3LytWbm9mbkhpaWppNjNUdnRibHc5dTNZWEZSODF5YUJ5Z1IwK3R4?=
 =?utf-8?B?bVdMV3VoQjM3bzd1R2dQR3lxajNuWS9odUo0dUw1QW50TkRUcElEVGRPT3Jp?=
 =?utf-8?B?WnBUanpmTUhsdXNhVCtoMzdCTDY0M2ZSN3lGUzlxZmhUd09pYXZ1Y1RuUE55?=
 =?utf-8?B?SzVPMFRNaGJKb2FVUDQvRmpVZzA0Tm1mQmo3TkswQVpOOEhIVkVyRUpGUlBi?=
 =?utf-8?B?b2xFREt3bjRwanpGMHVONk1NREtQWkRwM1g5YXF0SW9IbWNKR09tdndBcVJ2?=
 =?utf-8?B?M1pnRE4yVU13ZkU0ZjJSK3BLWUZsSFRZSytHODU3ZVdQamUwdXZhUDlnNUtO?=
 =?utf-8?B?ZUltNTRxWFQrSExqWDEwNWtnQnlZUnZxY2t2NTduUUVvMlUzaXFYTGVMcGln?=
 =?utf-8?B?QVNpUm15OU8vUUhjdktjbWd6eGpxcytsVGFmMVZhQ2V4V0paWFFPTjRtLysx?=
 =?utf-8?B?cXlJalNnN1g0bW8rOGwvaUd0SENETDJVd3hWRVM0NVpnQlMwalZsTjJIMXJE?=
 =?utf-8?Q?VjUm9gqZT7Y99IZMgBRp6ih+f?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d629ce6-5af5-4911-d78a-08dd50b0df8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 06:44:35.1349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /BL+sPzvXoDiz4fafeFGKoJGmeKsb89H+MbcmhfbTBS/1pDa8evPEsZ2bq6hZEjStYdPQYo9jj0eEZNyVjBySDgcokC/FwXZ2/XnATW5mZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com

VGhlIENhbGwgZm9yIFBhcnRpY2lwYXRpb24gZm9yIHRoZSAyMDI1IExpbnV4IFNlY3VyaXR5IFN1
bW1pdCBFdXJvcGUgDQogKExTUy1FVSkgaXMgbm93IG9wZW4uDQoNCkxTUy1FVSAyMDI1IGlzIGEg
dGVjaG5pY2FsIGZvcnVtIGZvciBjb2xsYWJvcmF0aW9uIGJldHdlZW4gTGludXggDQpkZXZlbG9w
ZXJzLCByZXNlYXJjaGVycywgYW5kIGVuZC11c2Vycy4gSXRzIHByaW1hcnkgYWltIGlzIHRvIGZv
c3RlciANCmNvbW11bml0eSBlZmZvcnRzIGluIGRlZXBseSBhbmFseXppbmcgYW5kIHNvbHZpbmcg
TGludXggb3BlcmF0aW5nIHN5c3RlbSANCnNlY3VyaXR5IGNoYWxsZW5nZXMsIGluY2x1ZGluZyB0
aG9zZSBpbiB0aGUgTGludXgga2VybmVsLiBQcmVzZW50YXRpb25zIA0KYXJlIGV4cGVjdGVkIHRv
IGZvY3VzIGRlZXBseSBvbiBuZXcgb3IgaW1wcm92ZWQgdGVjaG5vbG9neSBhbmQgaG93IGl0IA0K
YWR2YW5jZXMgdGhlIHN0YXRlIG9mIHByYWN0aWNlIGZvciBhZGRyZXNzaW5nIHRoZXNlIGNoYWxs
ZW5nZXMuDQoNCktleSBkYXRlczoNCg0KICAgIC0gQ0ZQIENsb3NlczogIFR1ZXNkYXksIDYgTWF5
IGF0IDIzOjU5IENFU1QgLyAxNDo1OSBQRFQNCiAgICAtIENGUCBOb3RpZmljYXRpb25zOiBUaHVy
c2RheSwgMjkgTWF5DQogICAgLSBTY2hlZHVsZSBBbm5vdW5jZW1lbnQ6IEZyaWRheSwgMzAgTWF5
DQogICAgLSBQcmVzZW50YXRpb24gU2xpZGUgRHVlIERhdGU6IFR1ZXNkYXksIDI2IEF1Z3VzdA0K
ICAgIC0gRXZlbnQgRGF0ZXM6IFRodXJzZGF5LCBBdWd1c3QgMjgg4oCTIEZyaWRheSwgQXVndXN0
IDI5DQoNCkxvY2F0aW9uOiBBbXN0ZXJkYW0sIE5ldGhlcmxhbmRzIChjby1sb2NhdGVkIHdpdGgg
T1NTKS4NCg0KRnVsbCBkZXRhaWxzIG1heSBiZSBmb3VuZCBoZXJlOiANCmh0dHBzOi8vZXZlbnRz
LmxpbnV4Zm91bmRhdGlvbi5vcmcvbGludXgtc2VjdXJpdHktc3VtbWl0LWV1cm9wZS8NCg0KRm9s
bG93IExTUyBldmVudCB1cGRhdGVzIGhlcmU6DQpodHRwczovL3NvY2lhbC5rZXJuZWwub3JnL0xp
bnV4U2VjU3VtbWl0DQoNCg==
