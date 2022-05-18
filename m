Return-Path: <kernel-hardening-return-21561-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 55D8AC433EF
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 May 2022 15:50:38 +0000 (UTC)
Received: (qmail 24017 invoked by uid 550); 18 May 2022 15:50:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23994 invoked from network); 18 May 2022 15:50:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652889027; x=1684425027;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=c2g+TUBC1/pI/Od7fgFqoX+P0rL1XVMNEFrcKCuHC3s=;
  b=AIfoJtWxfHSB2RkHSV1Z2d6J4s7A/VpHDWkiageZphYGbYen/XpAevnl
   ism//qksyeJihDTREPaJ2sEbI3Z3/ZiC/iOcFK8G9CMAQ+YPvhDbTFW7z
   O5dsu+NickVayit9GazP5axZLUdgfIIgQJjdBWY/bvtEOXQxqXKBybqxX
   e16zx3TQ1pkHzRL/D1K5/neT92e5gCZto2uBWDg/YfXFvwWyaMAIFSnfB
   RX8L2KOKQvvVlt8Vdp70qxxQyi6Z3P63Xgq3Ku3LG3e87SRxZd9RI/fJG
   sIjlvhJx2IvHTVS9NpyM9zUYevEMfGgPDmXCMrhz2vl91rfSOjWyCVjii
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="271867436"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="271867436"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="817500535"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atk29epn7soY4L+R9F31Gyx1QZ2vvHLwu2r81uWO/gjHEzN2GtkEb6eQeFlX4m6zwirFEqlhLnbKTsjoyPzPSdBOyTh1QFLiGSYsv29kJeqp3FuH44JNKVsat6LVYg8aBfWremxU6M9RI6jH9vZ0mGc8Hvg2tkQU8dhH6wUkkMZONvCw2VfKRTGeR3sdt5Cqr2Q2Yn8cEULdq3xOV2hZS5pEw1wlSNyKxg9C+9y087fjiigWPS3ewMhZaxYamRCYtgyAJXnpOVRyueqhgTeP2j+QlaR3uf1w54bIhN/6sfxUiETP32zRrYDwG2U7ctQFQrh9dHxH+RFexrTv0tHNtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2g+TUBC1/pI/Od7fgFqoX+P0rL1XVMNEFrcKCuHC3s=;
 b=cDiRCCbLT1XIN8QYzwhCVqBy3zJ7JKDG2MTGe1Hx12OSltS6EKBgwHJkV9HKR/Cl6p6Sakjz3+u0c8Eofd+6DwJTx5HjYggACxb7UgbKhpUa81qVvLtKJczUFn+Icn2JB+iJoO7ULfN4Ld2N/cIBP3AjhKsNYFGeeoma7rlUqiVQfmvpsbBqIUY99hie6i498ynHSKE82o/EvKQbTXObFhVuhfPX2JwjJ/eQjYcFvvRfSw4OcDDji3ZksVXW1bbTnbWBqFcVPhEXwCCTTFpN4wF/8OGSLCX5O8nNVFerCdxW1i3/tYUzBL7wvUOodLOGf6VZYqYBvsRuJ0TwRlP9fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "keyrings@linux-nfs.org"
	<keyrings@linux-nfs.org>, "gentoo-hardened@gentoo.org"
	<gentoo-hardened@gentoo.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "selinux@vger.kernel.org"
	<selinux@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net"
	<tpmdd-devel@lists.sourceforge.net>, Audit-ML <linux-audit@redhat.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "lwn@lwn.net"
	<lwn@lwn.net>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "fedora-selinux-list@redhat.com"
	<fedora-selinux-list@redhat.com>
CC: Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>
Subject: [ANNOUNCE][CFP] Linux Security Summit Europe 2022
Thread-Topic: [ANNOUNCE][CFP] Linux Security Summit Europe 2022
Thread-Index: AdhqzkvZUYsIzEfbS2Ok0K5VWG7sfg==
Date: Wed, 18 May 2022 15:50:11 +0000
Message-ID: <DM8PR11MB575091BB70382539DC3993A6E7D19@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7baac8e8-6823-49c8-83bf-08da38e61761
x-ms-traffictypediagnostic: BYAPR11MB2614:EE_
x-microsoft-antispam-prvs: <BYAPR11MB261492087022D83C4A4BAB36E7D19@BYAPR11MB2614.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 17H65JD32dqpIYfJHlUoAKCZmsTofZhUVMwHnVdtuAwWZoRqtzS44YKiihzH7mAAJxoHM0xH0NjGcWT1cNJ5pt67Le7u7e3BGZ1p39HVTFJWtZESg2Y/rT3ZzRIBEwzlWHipyfYkINj0/kIVTOSQrDZDoYLlkiYvB+fhymXnFJmKC5PEhsVONaAGjIqN2wxeoFF7uSkFor/+F/3uk1K+m7R1sAPqoVjcUCL7ey6wZFTMN7PjzG9U1o2e+tmGItEF2+6fKTB8qVdAGk2krB3vCCoF5MYfOHOW7eD3htReo2gryPag7q7438Q+1EnRQEMZQExvxfmv3/oRAPWutt6J1l/ZTFBuMPMfxu1UK9sKzXlYxVMenb7B38oRlIp65W+xDL415dTj8GHecNa04M0L8m2yzu1fxlT3mvNpY3PdJDprWzB42DmPzuXSWphfa94cLbD723TGP0FCvgeEOkehULz+ztXlshRzLBYPLMUOomg06WtfVrDdhKcrsEkOI8acoC+nwXqitzcmdziI82iGuP+3TFeddd9eyDsg4OPyozSIMzEbneU7jmSCRuJrBFRw9TyVhYWqJBSu+OjFgiASq2j36yM/qdYJnt4QmNtX1t8Irfm2qI+LTW7ivpcrAq/tY6OalTUCg6vwB2w1eN/weZ+vtRyWUCm5NX3lOcEY/1NrXrwHaeBUghax/V1xBAXrtAyUd3tapcOo2J+4eLUYXOoFaW0+0tzx/NA0BqITYrZVMcZMDIr54PjeUnoQn9TlQI28aTh0iz45mmsqk2QmYv/PuMPO7DzOq66bAzcA0aNOGs+3DLLuRipyCC2Dj5U5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(15650500001)(9686003)(83380400001)(508600001)(71200400001)(186003)(6506007)(38100700002)(66556008)(76116006)(64756008)(66946007)(66446008)(26005)(8936002)(33656002)(38070700005)(55016003)(7416002)(122000001)(316002)(66476007)(5660300002)(921005)(82960400001)(966005)(8676002)(52536014)(7696005)(2906002)(45080400002)(4326008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVVLTzBSTlN3MUkzR3ZpNU9EQlV5UzZUODRCNmJ2bnkyMHBiWjlYV0dRN0w5?=
 =?utf-8?B?N0JRbko2U05LV2Z0aTRBUXBqN0dxLzlKMHhjL0ZMTW9BU1dWVHhIRDJGK0xn?=
 =?utf-8?B?ZkpvM0FMRTVXSHpMUGNaZGFzN1B4UXBiYkdKWHdHQkJpRHFhM3B4MFZMMHlh?=
 =?utf-8?B?ejBiQVgrc2s3NmU3OC80aFRKa1MwQUt6VmZZSi9aWXhxbXUzZytlcU9xSkxH?=
 =?utf-8?B?b3NXWVZmR2hBc1dCa0dLSk9WZXJRZSttTnRwOXZ5R2U0ck1FUTV2SEhNSzNT?=
 =?utf-8?B?N0hkWEdhOFhyVnZhWFN3bUZOQmJLSTJOYk81OThKWTVGNHR3OVduWER0T0Z6?=
 =?utf-8?B?Ym5jYm1zemluSGR5WmhVU1FvS1ZUd0xoRmQ2TlhhVmxhcHRPYkphNitjNzFu?=
 =?utf-8?B?c2k0WU10RnlWd3F6N0VnTFJYMDJhRDlJYThMWmJTTjkwaUdRNXQ2Y1ZpTjNP?=
 =?utf-8?B?cWJLMHpjclYxTHZTSTFiV1NDOXBPRGp6N2RrczFxQVExZERUU3g1RUk2NWw4?=
 =?utf-8?B?K0pkTlNrcDJGODYwTW0vMnNlcjhBQzBqNnh6QnM1Nk1tNkJVbmVSY1pwZElj?=
 =?utf-8?B?WDVoajNLeTZjVVQzOUFBZWhFZDBIN25rU3FIODI2WWNkQ1M5algwVTA3TjJQ?=
 =?utf-8?B?dVVLc0gzQ21iN1RpNWhlVTN1RmFXUHNobU1YU0o2WTNoS1NDVDJlOCtiNUR2?=
 =?utf-8?B?TkFuNmI5MEdYdnAyTU50UHM4Z2V4ZGFYSWQxRkxEOXNWVmppSXllNGw2ZHJH?=
 =?utf-8?B?VlVGeTZXMEJDQ0REc0R6QTVwOFZjNGVoTzFGeEVUcEk3RGtFU3d0UFFtRC93?=
 =?utf-8?B?a2ZlMWo5bzY1d214Vkl1ZDFkRXpSK2tEa2xXZnVmY3RLR3hpcjVRZ200b2JC?=
 =?utf-8?B?empwdzhlTForWDBHa1F0bWk2YkhoWjdzRDZURzdDN0UrUTJ3SjRpV0ZBaXoz?=
 =?utf-8?B?Y2dQdXJ3TmdjdXM4OE9vVFBrbXBaU3AzVHdhdEpZZzRHYkhYd1VUWWRRNVdM?=
 =?utf-8?B?RGN5Rnl0TzNyVkVhWWNMV2VYNTdBUWpiTXJyTEpTQmRtQlQyRE1FZGx4b3dU?=
 =?utf-8?B?YVV5UWUzbVk3Wmc4Z2UvK0kzV0dPdzZBQ3JXL1FZWUdSQ3VpcG4zcStZRXg2?=
 =?utf-8?B?R2dhWGdhV2JsMTBERjI5L0Nxb04rUkVmSVVVTmR3QTlsZjg3QmxvRGFvcWhw?=
 =?utf-8?B?ZHRHRUtxUVNYeWthblh3a1VtNlllM1R5Ymw2V0QzRUN6emd0UXdSMldUUWxL?=
 =?utf-8?B?eTI2dDVCVDlCSjlKNE5NdTRGR2N1Z0x2Q2diVlRWQm52T09SSUFFdTFJTW5H?=
 =?utf-8?B?TW1hMmZ2cHV0cGFneExGd2kzZXJJN3hGMm54YnRsclhYQXNpRzRJcHRObUFF?=
 =?utf-8?B?UmJXdHVINEVoSXZpWm9iL1d2bnozenlwRUFoa1RLOFphazNpU1pVRTl0YXdL?=
 =?utf-8?B?dU5vcncyMVlPaFZEZHArY09ML2xUWnM0dWorZmNvUW1JN0hPcFZrTW02TkQ0?=
 =?utf-8?B?eGxrRlNDbWRXVDd3a3pNeTd2cDNhUTY1SmM2L2VOQlVBZEZNL1c1SmcyMnJZ?=
 =?utf-8?B?WGNseUMwVVc3aGNEQlBvaENHOXhsVnRUdDBYQTQwREFtM093SnA0RlkxeVRz?=
 =?utf-8?B?MDgrcjdJOFRDQjVLN21Hd0dqZ2Y0bU9SbC9STVhSbnQvaExYUVVvKzB1T2RW?=
 =?utf-8?B?WkZJRm82MUREWFUwYzlUVjR2M2VzUnlUT05UN3E5b3dBemFJSGhxMXYwc1Jy?=
 =?utf-8?B?TmpGN2ZoL3BVaGtWTlpMT3dMOFJnVmtWdWJpMUpkNHJiRU9VSm4veGFEUjY1?=
 =?utf-8?B?MThFM1orY2t5N0tYa3gyYzZEakRYRDNHSldNR2Z0Z0JTYmV0L3B0V2ZGZE94?=
 =?utf-8?B?ZXZMSklDNE1UZ2NweFZZcENZUjdJWjFQQkpiczlHdXpkeVpBbEFENWM4Rktp?=
 =?utf-8?B?UkJNdzhMUXdjZ2o5dXIxbGZPK0ZFdFNFeDJtOXVXQ29IckU5ZVJDbklFd0NL?=
 =?utf-8?B?eFYxclA3T21wZG40bHRGQzNoZjNnWlg4N2t2cFp5dlByeGpDYVJRaXNsY2NS?=
 =?utf-8?B?ejZEZXE2Z0dOc1hETFl1QzE2S2NGcXZFQjc1M1YvM1UxdVd4eHhUVHhyR054?=
 =?utf-8?B?RWhRTHV0TmJZVnRyTHFYV0RhOVh3QnMyOEJhMjY2SElRQndaV0hxTVR3Q3lj?=
 =?utf-8?B?NVlIdWtpaGx1M01URWR4Ymx6aDgxNUpiY2RhWGdVaWFwdnVRTE5vNHcxa2hu?=
 =?utf-8?B?OEFFeDFyZUtTVzJpR0grei9odVB1K2xkcmdXZ3VoUUxlaVV1WTRLTlV3d3hN?=
 =?utf-8?B?NmNUSVJlTWt4QVlpeHlhWmVJUjNxVmFQUGM1anl4YWNVMU1PYjlndz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7baac8e8-6823-49c8-83bf-08da38e61761
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 15:50:11.1621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aU2/KYvf/WUdRys8LsxsvZ5fWzxOF6d1UuHJkcbPvwaHxuc1xluBmiH968VIwE4oLX4kQAwzkYv9WovIjebbx/INI5zitmRZPKdAiuvw2Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2614
X-OriginatorOrg: intel.com

PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09DQogICAgICAgICAgICAgICAgICAgQU5OT1VOQ0VNRU5UIEFO
RCBDQUxMIEZPUiBQQVJUSUNJUEFUSU9ODQoNCiAgICAgICAgICAgICAgICAgICBMSU5VWCBTRUNV
UklUWSBTVU1NSVQgRVVST1BFIDIwMjINCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxNS0xNiBTZXB0ZW1iZXINCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgIER1YmxpbiwgSXJlbGFuZCAmIFZpcnR1YWwNCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQ0KDQpERVNDUklQVElPTg0KIA0KTGludXggU2VjdXJpdHkgU3VtbWl0IEV1cm9w
ZSAoTFNTLUVVKSBpcyBhIHRlY2huaWNhbCBmb3J1bSBmb3INCmNvbGxhYm9yYXRpb24gYmV0d2Vl
biBMaW51eCBkZXZlbG9wZXJzLCByZXNlYXJjaGVycywgYW5kIGVuZC11c2Vycy4gIEl0cw0KcHJp
bWFyeSBhaW0gaXMgdG8gZm9zdGVyIGNvbW11bml0eSBlZmZvcnRzIGluIGFuYWx5c2luZyBhbmQg
c29sdmluZyBMaW51eA0Kc2VjdXJpdHkgY2hhbGxlbmdlcy4NCg0KIFRoZSBwcm9ncmFtIGNvbW1p
dHRlZSBjdXJyZW50bHkgc2Vla3MgcHJvcG9zYWxzIGZvcjoNCiANCiAgICogUmVmZXJlZWQgUHJl
c2VudGF0aW9uczoNCiAgICAgNDUgbWludXRlcyBpbiBsZW5ndGguDQogDQogICAqIFBhbmVsIERp
c2N1c3Npb24gVG9waWNzOg0KICAgICA0NSBtaW51dGVzIGluIGxlbmd0aC4NCiANCiAgICogU2hv
cnQgVG9waWNzOg0KICAgICAzMCBtaW51dGVzIGluIHRvdGFsLCBpbmNsdWRpbmcgYXQgbGVhc3Qg
MTAgbWludXRlcyBkaXNjdXNzaW9uLg0KIA0KICAgKiBUdXRvcmlhbHMNCiAgICAgOTAgbWludXRl
cyBpbiBsZW5ndGguDQogDQpUdXRvcmlhbCBzZXNzaW9ucyBzaG91bGQgYmUgZm9jdXNlZCBvbiBh
ZHZhbmNlZCBMaW51eCBzZWN1cml0eSBkZWZlbnNlDQp0b3BpY3Mgd2l0aGluIGFyZWFzIHN1Y2gg
YXMgdGhlIGtlcm5lbCwgY29tcGlsZXIsIGFuZCBzZWN1cml0eS1yZWxhdGVkDQpsaWJyYXJpZXMu
ICBQcmlvcml0eSB3aWxsIGJlIGdpdmVuIHRvIHR1dG9yaWFscyBjcmVhdGVkIGZvciB0aGlzIGNv
bmZlcmVuY2UsDQphbmQgdGhvc2Ugd2hlcmUgdGhlIHByZXNlbnRlciBhIGxlYWRpbmcgc3ViamVj
dCBtYXR0ZXIgZXhwZXJ0IG9uIHRoZSB0b3BpYy4NCiANClRvcGljIGFyZWFzIGluY2x1ZGUsIGJ1
dCBhcmUgbm90IGxpbWl0ZWQgdG86DQogDQogICAqIEtlcm5lbCBzZWxmLXByb3RlY3Rpb24NCiAg
ICogQWNjZXNzIGNvbnRyb2wNCiAgICogQ3J5cHRvZ3JhcGh5IGFuZCBrZXkgbWFuYWdlbWVudA0K
ICAgKiBJbnRlZ3JpdHkgcG9saWN5IGFuZCBlbmZvcmNlbWVudA0KICAgKiBIYXJkd2FyZSBTZWN1
cml0eQ0KICAgKiBJb1QgYW5kIGVtYmVkZGVkIHNlY3VyaXR5DQogICAqIFZpcnR1YWxpemF0aW9u
IGFuZCBjb250YWluZXJzDQogICAqIFN5c3RlbS1zcGVjaWZpYyBzeXN0ZW0gaGFyZGVuaW5nDQog
ICAqIENhc2Ugc3R1ZGllcw0KICAgKiBTZWN1cml0eSB0b29scw0KICAgKiBTZWN1cml0eSBVWA0K
ICAgKiBFbWVyZ2luZyB0ZWNobm9sb2dpZXMsIHRocmVhdHMgJiB0ZWNobmlxdWVzDQoNCiAgUHJv
cG9zYWxzIHNob3VsZCBiZSBzdWJtaXR0ZWQgdmlhOg0KICAgIGh0dHBzOi8vZXZlbnRzLmxpbnV4
Zm91bmRhdGlvbi5vcmcvbGludXgtc2VjdXJpdHktc3VtbWl0LWV1cm9wZS8NCg0KDQpOb3RlIHRo
YXQgZm9yIDIwMjIsIHdlIGFyZSByZXR1cm5pbmcgdG8gaGF2aW5nIGJvdGggTm9ydGggQW1lcmlj
YW4gYW5kDQpFdXJvcGVhbiBldmVudHMgKExTUy1OQSB3aWxsIGJlIGhlbGQgaW4gSnVuZSBpbiBB
dXN0aW4sIFRleGFzKS4NCiANCg0KTFNTLUVVIERBVEVTDQogDQogICogQ0ZQIGNsb3NlOiAgICAg
ICAgICAgIEp1bHkgMQ0KICAqIENGUCBub3RpZmljYXRpb25zOiAgICBKdWx5IDI2DQogICogU2No
ZWR1bGUgYW5ub3VuY2VkOiAgIEp1bHkgMjgNCiAgKiBFdmVudDogICAgICAgICAgICAgICAgU2Vw
dGVtYmVyIDE1LTE2DQoNCldITyBTSE9VTEQgQVRURU5EDQogDQpXZSdyZSBzZWVraW5nIGEgZGl2
ZXJzZSByYW5nZSBvZiBhdHRlbmRlZXMgYW5kIHdlbGNvbWUgcGFydGljaXBhdGlvbiBieQ0KcGVv
cGxlIGludm9sdmVkIGluIExpbnV4IHNlY3VyaXR5IGRldmVsb3BtZW50LCBvcGVyYXRpb25zLCBh
bmQgcmVzZWFyY2guDQogDQpMU1MgaXMgYSB1bmlxdWUgZ2xvYmFsIGV2ZW50IHRoYXQgcHJvdmlk
ZXMgdGhlIG9wcG9ydHVuaXR5IHRvIHByZXNlbnQgYW5kDQpkaXNjdXNzIHlvdXIgd29yayBvciBy
ZXNlYXJjaCB3aXRoIGtleSBMaW51eCBzZWN1cml0eSBjb21tdW5pdHkgbWVtYmVycyBhbmQNCm1h
aW50YWluZXJzLiAgSXQncyBhbHNvIHVzZWZ1bCBmb3IgdGhvc2Ugd2hvIHdpc2ggdG8ga2VlcCB1
cCB3aXRoIHRoZSBsYXRlc3QNCmluIExpbnV4IHNlY3VyaXR5IGRldmVsb3BtZW50IGFuZCB0byBw
cm92aWRlIGlucHV0IHRvIHRoZSBkZXZlbG9wbWVudA0KcHJvY2Vzcy4NCg0KV0VCIFNJVEUNCg0K
ICAgIGh0dHBzOi8vZXZlbnRzLmxpbnV4Zm91bmRhdGlvbi5vcmcvbGludXgtc2VjdXJpdHktc3Vt
bWl0LWV1cm9wZS8NCg0KVFdJVFRFUg0KDQogIEZvciBldmVudCB1cGRhdGVzIGFuZCBhbm5vdW5j
ZW1lbnRzLCBmb2xsb3c6DQoNCiAgICBodHRwczovL3R3aXR0ZXIuY29tL0xpbnV4U2VjU3VtbWl0
DQogIA0KICAgICNsaW51eHNlY3VyaXR5c3VtbWl0DQoNClBST0dSQU0gQ09NTUlUVEVFDQoNCiAg
VGhlIHByb2dyYW0gY29tbWl0dGVlIGZvciBMU1MgMjAyMSBpczoNCg0KICAgICogRWxlbmEgUmVz
aGV0b3ZhLCBJbnRlbA0KICAgICogSmFtZXMgTW9ycmlzLCBNaWNyb3NvZnQNCiAgICAqIFNlcmdl
IEhhbGx5biwgQ2lzY28NCiAgICAqIFBhdWwgTW9vcmUsIE1pY3Jvc29mdA0KICAgICogU3RlcGhl
biBTbWFsbGV5LCBOU0ENCiAgICAqIEpvaG4gSm9oYW5zZW4sIENhbm9uaWNhbA0KICAgICogS2Vl
cyBDb29rLCBHb29nbGUNCiAgICAqIENhc2V5IFNjaGF1ZmxlciwgSW50ZWwNCiAgICAqIE1pbWkg
Wm9oYXIsIElCTQ0KICAgICogRGF2aWQgQS4gV2hlZWxlciwgTGludXggRm91bmRhdGlvbg0KDQog
IFRoZSBwcm9ncmFtIGNvbW1pdHRlZSBtYXkgYmUgY29udGFjdGVkIGFzIGEgZ3JvdXAgdmlhIGVt
YWlsOg0KICAgIGxzcy1wYyAoKSBsaXN0cy5saW51eGZvdW5kYXRpb24ub3JnDQo=
