Return-Path: <SRS0=A03q=KA=lists.openwall.com=kernel-hardening-return-21249-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3227C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 19:51:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADB00613B3
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 19:51:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADB00613B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21249-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1635 invoked by uid 550); 5 May 2021 19:51:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1603 invoked from network); 5 May 2021 19:51:30 -0000
IronPort-SDR: mV8lOJFhgppY8oNDyPHXsVTQu1uD9HTcGaRZXyAoEmAJYXt0Z/oodHQ0sy49Tct+5AFcANvJNb
 k7tzWSxk1bjw==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="177849487"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="177849487"
IronPort-SDR: ZYNUFZDVwsdhcyA9AgZAijmgoz76rFRNpfuKpdbdZKJAuavo+6WDqVod33RiCUSaEgPy2YMPoE
 Zf1XtSVnLpQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="539666969"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTRU3gNRGK5L0StzLTkCDM5x4cR4PcyjLoI9U02JWDKNmzGscpFZM2fx+YQg6LMNWMmlam4RAMx6V1CgBowawxAqicX+Mz5tvFoMaf3/YO52VerUTx0xGjdPGsls/oAZVWalJVZJJxyVF6/n5siDOcWg/sIgvKrX9AzFV7GC2QcVDa+CaUUQVxEdXDyDbGR8T5xH8oYBYbgKtqAhobHm4JWMIzCva0WrWS3SX1QiUPEm9ANbJnUUt6Y02Vqsv3psW2L3x1yzEEt+7yJZfB+UW3XWLvFwRsOLt1QTqBArhWWXVD7FNnJ3gzJCWP997FBna1vzNqOas6TJew5e8EyK9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtgWuFbJzdkte8AW5E/s648qVW3PxdbOi4aHP7aUZZ8=;
 b=f8s/1MN5mld47LjTbW1rLQqfW9+SY8SfJOW4LwtnZizKX5WwXqww+qBIs4FBrKi/zg2F/FhALz1hkaWqiQyJQENDc9SZ3Yj7eyAgMQSUmQnff9yUhJ7nJVTm0Vz32A1cFsxr9gjIC7bz7O/U30vvIM5axm9NoiZAeHxHy9nKdalHzqAeugcJMRhp2U4yOAjrXoea3GQIEAG54deHeNd7t4sAClvVzDRaM4wkPuwvYKc9qROIYGdagVx8io/E05l4zbuOneOVZk8xCrKBExfgveHZxDphYX27Alqv2MmDkqAUQfB5d475F5rIpCRRNJCfqeosOZxg4oNRDZ7dtVIp/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtgWuFbJzdkte8AW5E/s648qVW3PxdbOi4aHP7aUZZ8=;
 b=xi/Vmb80LWdyezxQ2N+tXXf5FqQFqs4ZQUOM/hi3ffC31ZorScobqbePTClU78c25zVLl1mkKvePIJrVJKK3eG4tTxDe6e/pmpyY6qgSMQMZY6aPsw/Z1u59eUT75LbRtfG2QBsRTCBu+m8+o9S38v/OqfRXXCfMTV6jDMj8FcQ=
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "keescook@chromium.org" <keescook@chromium.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Thread-Topic: [PATCH RFC 0/9] PKS write protected page tables
Thread-Index: AQHXQUYg7uLEQArpKEKF+xaanI/X46rUbFiAgADhFYA=
Date: Wed, 5 May 2021 19:51:08 +0000
Message-ID: <16772f10955e1607fcaff9acb701ff27907a11b1.camel@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
	 <202105042253.ECBBF6B6@keescook>
In-Reply-To: <202105042253.ECBBF6B6@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3deaece-4654-488b-75fe-08d90fff20a4
x-ms-traffictypediagnostic: SA0PR11MB4558:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB455883EA41D1CEAB3D17438AC9599@SA0PR11MB4558.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KDmsjna1Rq2osFnHvuUVTwg9bNdjJLqVoBLZP1eOBnXeh+pwzjxA/1FfhSlnlxs/FiA6CcJ495au5GrrKI2SnHmtN/gBN/q7aHQhxU7qLbuxUWtpkA12t2H46KX865pX52fW9CGAQUcZXrk1UFYJXo1PHJ820CA5Dp7DxcsiUbg1oxlxEyZbCRH0qr4tzt7OJVll0iZ1OUg3fM/wb9zcZ8EUBwp7YDvLCw0al4oEk3FJOIimi9TbpDkATwT/hTrntqfWhQc2MFKX+9jAp1Q2NOzb4OCCKONSl1MdNBupZCKrhYEvlemQb0s9cZYvrbZzOtH04yoIqarV+aeBaEV3ze9owbpW3CMX26FdlluaL/tpboGvzLnx2s2mpd8IH/ty/EQrzHKJddeb+HshYv5tZwgRlJo9hcAzW09VCOEdsArXsZE4qc+p2E331eNWbQgkVe2LrypORgdMhoJ+ebYaj2nbEwt0gEjYYOKAL0QWEnvVzJXCHkSihrwkDxBXr6TFzNOohRl1yL2GTxVA0hghBA3xE+tDt2ANpG/qt43ZX3Nll1j8B+taxX6Bnypk3vkxYK4cyHjeKw99y+nUXX56AKhw7KlUiP4zfX15X+3Omfz9Zhbr7xhFuybnHUINB/KDFU1PJ+h4HQVltjAZXAO0MaQaONwslvR6xN+vkJ/2Egw4orh/xWrIPzfwiL2NJ/2N
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(6916009)(71200400001)(83380400001)(7416002)(36756003)(38100700002)(478600001)(6512007)(186003)(966005)(2616005)(26005)(54906003)(8936002)(316002)(4326008)(8676002)(86362001)(6486002)(76116006)(91956017)(66556008)(5660300002)(6506007)(66446008)(66476007)(64756008)(122000001)(2906002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RGpuclFYc3hJekliYTllc1lzN2g5WldPL1ZjSlFNcTRvYnV3eWVBYzZEeFM4?=
 =?utf-8?B?R2NrZW1rcElZOXQxL05LRFdLb2VOczFqMGtmL0ZFd0ZLL2FBRjJ1L0o5blhw?=
 =?utf-8?B?Y3l5WUpMSVZNRHpMQnVmbUkwQ0JGTHFqY0RtVFBlZTdwaCswYy9VVTJBTmRn?=
 =?utf-8?B?MDY4RHdnTW1ETUZrVkx1YXJCOGtNMHdwTlhGVU53MXdqMHNVc0VmUUFuTHdL?=
 =?utf-8?B?eW4wSmVOWm5xVDF6SXRGNmdGTXR6K2pya28wb2dkUXVjcDdVVGk3ckRZcHlC?=
 =?utf-8?B?WWt4M3MzOVlyNXBTY2tNOE9EVmR3TSt4ZEQ5Vm1Vb08zejNxdHZoT3RzMzZv?=
 =?utf-8?B?RkZCb3ducmNSUEQrUFI4VDFZUUxYNnJrbU9oQmJoNHNreXpKd3JlQkdXa0Iv?=
 =?utf-8?B?K3JZdk9jL29DSW9zQ3BHc3V2eFlaZVZ1clVtUDhUWXZDOTVpcmgzR2s2ZjR1?=
 =?utf-8?B?U1piVDVPMy9kakV2N3dMMmlLYW5xQndwdXBndUVYUEpLSUI0bklSNk1pc2NM?=
 =?utf-8?B?d056L04zNWNZUlNEVXloTTh3S1ArZTJkT2R6QTkxQ3RvdTQ0cUQ4d1hwUmNp?=
 =?utf-8?B?eG0rSXJFdTV0SDNVMUxNU3cwRWYrS3BNZnVEZDY1Uk16Wmpydk9sdHJSeTNt?=
 =?utf-8?B?eU9TQkwxeldna3laR0laZmFOdUN3NkFEWWtwcTVKSHExWmwyVXVjNkZHdjV5?=
 =?utf-8?B?VmJjaFdHMHhjOU5LSzRJNFBrankzVVh4TjlWNjhIUk9BMEQrYzZuSVNwZmxs?=
 =?utf-8?B?M21kWVVEd0VNZmxEQXErblNVSzZvS25rRzZ4aGFPQ09RUDIxeVlrTTlXOGxa?=
 =?utf-8?B?VkZOeVQxck0zZGtsNHNVN0FOQ01RYjNuSS83cWM1aVRCYVlxY3htajQrUjRS?=
 =?utf-8?B?aURKem1TK0FEWkxQZHoyWWFxVGdHWVJxbkVzT2dGbUdHdnpkT0hmbFhoeDFL?=
 =?utf-8?B?Z1hFanBoeTZGQzlCR3h5b2N0WXlmM3hMU2ovbDYxbWtqZmozTTJ4SWE2NHk4?=
 =?utf-8?B?eFZTdjVtNVVreXEyVm1Hb3pzWW4wcnFKMW9IN3dXS3BmMnlFMnNlWkhkZTRO?=
 =?utf-8?B?anVLOUIvcHlQSmtSRHY1QTNwV0pBcnd5U2pFN0Rla1VjKzBpeE42MWN2NGcv?=
 =?utf-8?B?eHJXUzFUeVp6Z0Z1SURJMExoZkRWYjF5R2VRc1diTEk0L2VJT3UyaG5zbzFM?=
 =?utf-8?B?d0lrV3BNckxUUk5DaDNuN2d3TUJTR0JydUZsa1ZTMGV6MHBzYm91ejh4eFNH?=
 =?utf-8?B?SkJHTTRwSmhtdDJ4bmFWSmZobFE0d2xNT2p2RGViM2t2ckZDQkpYUDkyS1dZ?=
 =?utf-8?B?dEhsL2pyRXpYVTFoNm00dzB3ekNRL0ZhNDRpaVIyNmZlM1lGSGJoMm81UWxy?=
 =?utf-8?B?emZoaktZbXpwMVFRTmFSZ0JJalNNQXV4NXVubXg0enJJb1NVcUM4TTNHVmJQ?=
 =?utf-8?B?L002bExwenlpMEcyYkRza0dxU2FNbzhwVkRMZEI0TTV5ZysvcG1IVnViOXdJ?=
 =?utf-8?B?SGpBamM1RkhDeFNkbG8ybERxU2ROOWwxZlRrSUdia0p5Q0dOOWcxM004Ym9r?=
 =?utf-8?B?cWhaVkYwZWRiVkZ5czBaeGR5cnpqZFV6Ylgza1ZtZlRMWjI2b3NTUDRzcjNq?=
 =?utf-8?B?b2ZMMnN3NUtYY0hIVnVVZXRsRG5QSnZpV0JGMXVTSTRtR1UwZWU4VUIrZThC?=
 =?utf-8?B?UDlRVUJFZTEySTU3OW5lZDZIa0VSb0JEUVByclFjckYvKzRJTzZhay9EdFZx?=
 =?utf-8?B?dUhyZTZ6RitQaW03VnByQmJFZkp4MTN1RjdrL0NkS3ZySTVtaW9QRkFjenBz?=
 =?utf-8?B?TlJDcmoreUpQMVFWYnF2QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5DFDCEE81A975458408A0C52DDA5C34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3deaece-4654-488b-75fe-08d90fff20a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2021 19:51:08.7532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bD+hbK5k+6Da1z6iJ8UbsxDjHG6TRon6KFmm/29fUdZM8OTglwxHnunkiI7aYUOXjlaKmhXZz7WzGW2gelwxxr5XN5wDQDOuX+489xdzkU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4558
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA1LTA0IGF0IDIzOjI1IC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+ID4g
aW5mcmFzdHJ1Y3R1cmUgZm9sbG93LW9u4oCZcyBhcmUgcGxhbm5lZCB0byBlbmFibGUga2V5cyB0
byBiZSBzZXQgdG8NCj4gPiB0aGUgc2FtZSANCj4gPiBwZXJtaXNzaW9ucyBnbG9iYWxseS4gU2lu
Y2UgdGhpcyB1c2FnZSBuZWVkcyBhIGtleSB0byBiZSBzZXQgZ2xvYmFsbHkNCj4gPiByZWFkLW9u
bHkgYnkgZGVmYXVsdCwgYSBzbWFsbCB0ZW1wb3Jhcnkgc29sdXRpb24gaXMgaGFja2VkIHVwIGlu
DQo+ID4gcGF0Y2ggOC4gTG9uZyANCj4gPiB0ZXJtLCBQS1MgcHJvdGVjdGVkIHBhZ2UgdGFibGVz
IHdvdWxkIHVzZSBhIGJldHRlciBhbmQgbW9yZSBnZW5lcmljDQo+ID4gc29sdXRpb24gDQo+ID4g
dG8gYWNoaWV2ZSB0aGlzLg0KPiA+IA0KPiA+IFsxXQ0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xrbWwvMjAyMTA0MDEyMjU4MzMuNTY2MjM4LTEtaXJhLndlaW55QGludGVsLmNvbS8NCj4g
DQo+IEFoLCBuZWF0IQ0KPiANCj4gPiBbMl0NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
a21sLzIwMjEwNDA1MjAzNzExLjEwOTU5NDAtMS1yaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbS8N
Cj4gDQo+IE9vaC4gV2hhdCBkb2VzIHRoaXMgZG8gZm9yIHBlcmZvcm1hbmNlPyBJdCBzb3VuZHMg
bGlrZSBsZXNzIFRMQg0KPiBwcmVzc3VyZSwgSUlVQz8NCg0KWWVhLCBsZXNzIFRMQiBwcmVzc3Vy
ZSwgZmFzdGVyIHBhZ2UgdGFibGUgd2Fsa3MgaW4gdGhlb3J5LiBUaGVyZSB3YXMNCnNvbWUgdGVz
dGluZyB0aGF0IHNob3dlZCBoYXZpbmcgYWxsIDRrIHBhZ2VzIHdhcyBiYWQgZm9yIHBlcmZvcm1h
bmNlOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vMjEzYjQ1NjctNDZjZS1mMTE2
LTljZGYtYmJkMGM4ODRlYjNjQGxpbnV4LmludGVsLmNvbS8NCg0KSSdtIG5vdCBzdXJlIGV4YWN0
bHkgaG93IG11Y2ggYnJlYWthZ2UgaXMgbmVlZGVkIGJlZm9yZSBwcm9ibGVtcyBzdGFydA0KdG8g
c2hvdyB1cCwgYnV0IHRoZXJlIHdhcyBhbHNvIHNvbWVvbmUgcG9zdGluZyB0aGF0IGxhcmdlIGFt
b3VudHMgb2YNCnRyYWNpbmcgd2FzIG5vdGljZWFibGUgZm9yIHRoZWlyIHdvcmtsb2FkLg0K
