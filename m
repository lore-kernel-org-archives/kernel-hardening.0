Return-Path: <SRS0=WpKy=LU=lists.openwall.com=kernel-hardening-return-21327-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587BAC49EA6
	for <kernel-hardening@archiver.kernel.org>; Sat, 26 Jun 2021 09:37:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C0B4561621
	for <kernel-hardening@archiver.kernel.org>; Sat, 26 Jun 2021 09:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0B4561621
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=windriver.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21327-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29827 invoked by uid 550); 26 Jun 2021 09:37:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9363 invoked from network); 26 Jun 2021 00:58:01 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdEKdR388DvZ1I7huGHnj7eaZehDANjpgJ/RnHnGFYpJ9ZsjBHgFZCe8xjmrn+YGuxJ40H0zjmEqoVv8GOpWYWoFsfUaBEZxlrEhnGgU9wZrWjWH2zQyUmtW0YwmZcEIUVINQH2z7epJGLJVG4r2FD84BqUnkwVGZICwxtEgIUWiCotmEL6q3tB3rFzxHA9IImbnX178vmmc76mbwbuFtEADlzB+IYppKztIpPQt/KrSRIw0Rr1xVRPnc7/gnYz0q8+1jpWuYZbX9zZg5bDWQorJ+vP60dw3Yc1Gxzl4+AclzubbbzxMIJiO+8lTKDEUGn6r3IoSVx8E96Y0VQ3hpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4tUrAvWYhNoiFePlKAuFf4mJ5dhoqeayQP2/whCo9o=;
 b=DY8cr/7JWfcCCl5K3RP25XPOAM0dEYoFP1+GtxzBf+DnZ2V5Ubpg7VhgOmnEvbcpBNM2GIDHfxTeYtTxJj1ccluQ+ZR9wuzOR3BDtbmngW/DuOpgUaMRxLM1x+toBv33ZastDV8E5/vcFfSdQGeq0xgN1pYaVpeaKABVmf9qae9Mu48/umh+eDhoo/MXMBxzh+p2xlLweDTl/oe6qGoAFC2NzRbhl4r5FFdCfe11wyMkFFIkC3M+GpmskxbouFgGywGRJ4Gt3eb0NXYDtVLkIdSQz0PKya/JVprunh6eiyXOdvbewg3nQfGG5UCfSBTOq/QDhiZUKrHBlvgxgvEtcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4tUrAvWYhNoiFePlKAuFf4mJ5dhoqeayQP2/whCo9o=;
 b=Ra6HhbJ+ZVghGrXtv/6Hc8WMpUBHhGq0wLqaCNpqmHZfGmUsmLrRMxdm8Y6F6q5X/tQrwX2i7HN0QfaK3Lg5YnTOMBXXWxWax9U6zaMeDaMytEbcckb3yXwikl8xTNRZNAvmGxcc2JYyAEMEABXBKM666m7fs2biQufrfzXOlNE=
From: "Zhou, Yun" <Yun.Zhou@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
        "Xue, Ying" <Ying.Xue@windriver.com>,
        "Li, Zhiquan"
	<Zhiquan.Li@windriver.com>
Subject: 
 =?gb2312?B?u9i4tDogW1BBVENIIDEvMl0gc2VxX2J1ZjogZml4IG92ZXJmbG93IHdoZW4g?=
 =?gb2312?Q?length_is_bigger_than_8?=
Thread-Topic: [PATCH 1/2] seq_buf: fix overflow when length is bigger than 8
Thread-Index: AQHXad6lRHP40od2dEqvpDuYaDytHasldaNF
Date: Sat, 26 Jun 2021 00:57:18 +0000
Message-ID: 
 <SN6PR11MB3008E8AED96764C86DDC2F6C9F059@SN6PR11MB3008.namprd11.prod.outlook.com>
References: 
 <20210625155348.58266-1-yun.zhou@windriver.com>,<20210625122453.5e2fe304@oasis.local.home>
In-Reply-To: <20210625122453.5e2fe304@oasis.local.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: goodmis.org; dkim=none (message not signed)
 header.d=none;goodmis.org; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [111.199.71.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c820c38b-7a43-49d9-1ac5-08d9383d58db
x-ms-traffictypediagnostic: SA0PR11MB4558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: 
 <SA0PR11MB4558720CCA0B92966D21943A9F059@SA0PR11MB4558.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 EgWQbAC4ri+zfDgh0pSyC5lUmIZbp9dyyp8CjfJ+itB9sHNm03TTyTDeZE7rI8v5Z9gU4uHvqmYcihN2htER6GaLZALZYkAgJHMq1F9RbBQE//ALrZGasBwWgPpR7tavw/t4uiUI2qQjMZe3PwwJvJa6U2SMKz2PthuIHniPwZS1YYIjqA/Jee+5nRI68tsxxWj1wvbSwE9l3MACvbCppttNKtVVThs5NzpNi2TNafcYNcLrx68pmbfAwaAXgocJJfdDz4DvoWA5/j0wsnYKw0Z5nPggWB//UFo2vO//0gia69hJ7NXjLC0d7Tg6BHwSfdCrEWEX5699UfLG3PcZSt5nH7TWDbxDXGw9QuXWnb6Tun9FnmhAz+0GwhsuW+wqf5kDS0mL8jPNewqa2SAkG7MX2/XV1fts+lz327COw6xZ79ArYx3kQ4E6vYchxtGOXWepwWAEdKc0g6KpNMIcutSZ7Bak3OR9XHHbAq7QX2NAyGAvbgBhlXKr+VQNxxUQlsknN2pSGyw1YsjyqSBV3i76NZo7e+U6+j4XNS4BhQ97bzOrGAyrYc36/gMXj8/B6s3o5GLJAZ7GnPXY83N6hJ0Z5ieM2gEqLtP2b8Ygm18+UsScGdfqs0RAXeMX69BH6moUYEqwRmaRPhMxxcfTujCkJgJQQA49bXJSJpBr3XVpbHPuHM2sSXZMfaPqLPJX7zFOD/NPag1to0CpTHzqGw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(136003)(376002)(346002)(396003)(366004)(86362001)(52536014)(66556008)(66476007)(64756008)(91956017)(66446008)(76116006)(5660300002)(2906002)(478600001)(66946007)(19627405001)(107886003)(186003)(7696005)(38100700002)(122000001)(9686003)(4326008)(224303003)(71200400001)(6916009)(316002)(8936002)(83380400001)(55016002)(54906003)(26005)(33656002)(6506007)(135533001)(13296009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?gb2312?B?VXJrVUJ6S09NdjdWYTY1Z29scFA5N1NRVXFWZEF0cDNjNi9XaDlFQ2NlelhJ?=
 =?gb2312?B?U1gwbU1rRWFhenlHaEpPZm5vZVdGaDNzU0cwYVpxZ3NyVzMyVVNrUTdndnh5?=
 =?gb2312?B?ckRESDlqS1YxdVZNVHVGRFlQaXpORjllVGQvNGJjbTUvdmw1U2pQQXc4OFkz?=
 =?gb2312?B?NkhtQXFmbjA4M1pjVnZNZzNNd0c2eFo4QjVLRjdaSkdjbFd2SWVXMnlYbUxI?=
 =?gb2312?B?aXNSSjRNeDl0NGJCNU9iTld4WHpQUDdQVFgrR2Z1S2tuVlV4aU9mMnJWY04r?=
 =?gb2312?B?Q2gzeHIvM3FheElxSjRjZ28xTWxtRkhrZ0dzYmJqei91TSt3QmV1NDVvSTZq?=
 =?gb2312?B?ZityWmNYTEJFWGU1c1pNdjNxSTNlM3FJck1lN1BCUmxOWkRiOUM2ZFRsYlFF?=
 =?gb2312?B?U1pPU2JNTXpKQTloY2N1SDBLYnJMS2NDeXAwRTJvc0RjTXBrU1BkZCthdFZC?=
 =?gb2312?B?L2U0dG9LaXZmU2ovN0M0Q2FCcmFUWVZjWmxjMVNBM1AwM2VncEo3MmN6VGN5?=
 =?gb2312?B?QXE4QkpjZ0dGMEE4VzJrR0hRekpoQ2RQalBkMFp3STdaSEcvQVRWSWo5czlu?=
 =?gb2312?B?YldrYkUwRFpabWdqbWdLOUJWNGk1NmY4REpTU2hwL2xUc2pZUm9SK2ZtbFEv?=
 =?gb2312?B?Zi9wUWV1S05TU2VEUm5OZFhjUjhkejd5SlVXY1RzK2I1TzY5azhLUDhyaHd4?=
 =?gb2312?B?YitDVjgyT2hpL2lBT2VMeFNhMlE4NytpTGdkUWNoU1UxSVJpT3ZGVk15RmN4?=
 =?gb2312?B?L0REbEh1d3VySy9IcTBSaTMxU05XT3hIUlFqZzNkUlRGYlE5czFBNHdUVHA2?=
 =?gb2312?B?R3pxQUpFL1FnZGVwY1NnRVU1d2lvdWF5MTNXZ1htME1RWjZqUlJSZ2RxdGRJ?=
 =?gb2312?B?SVZlRjJtczZ2THdmeEkyN3RsUlBrVStLTzNPUkphUFEwbzF0akxzOUtHVW8v?=
 =?gb2312?B?Y0FzZWxMU3QvZm00YWlTYjdRSjRSZG5KTTM5NmFQcE8vd08vYWtmZDVabzFu?=
 =?gb2312?B?WHhZeGQ1WXU0ZTgxdVF3RFRVaFQwSkdZOVlnTHdleFlFREREQ0tYSkN3dXdO?=
 =?gb2312?B?ZSsxbDJURmlFdG91eEJmb2xTc2UrTktWeVplTWdXRkFpemxmdFhEVmpMU1Qz?=
 =?gb2312?B?UUxXRWoyWTB2RC9BM0hwQ3JrM3RONUg4aDJCQ1JtK1JHOTNZNFpCTFJtM2xm?=
 =?gb2312?B?TW1BS3ZoU0JDYUorZjhXbWxFaFJXeWJGSS80QjBBT2ZUeEUwU3BKRHc5Nlpy?=
 =?gb2312?B?QmpwWWQvUE55UGpvOGViRXJpZ28vcDlYR2Z1YlA3dk0zVm5Hb3pwOFhFVUNs?=
 =?gb2312?B?MWNHRmMrbmpWUDlIanhwM094S2RCRk1QSEhyNm4wK2RtelY5WlRyUm95SjQv?=
 =?gb2312?B?Q0hRclpZN3VWQ0ZXR012RWNNbkJ2SzBaMlJKOVFXdkx1eGFsNUpuOUdDNnE0?=
 =?gb2312?B?eEJncEtNVlBGclZzNGREcVQ3Sm5ZZ1RLRlI1UVVRbnJyTm9SQ05ENExtdFIr?=
 =?gb2312?B?cG9tZ210alFrc1dQV3EyK3RMNUUyWmRQYk5jb05lQ0NlUEZQK1pmNVF4WDFD?=
 =?gb2312?B?WVRYQVdTN25qYmNaMWVVSEZiOVZuZS9wTTJkb1V1eGhGWWgrVHZCOTgyK2xC?=
 =?gb2312?B?dkN6b29tNTY2WmkxUjgrOGFnVGk2QWhXL1ZjTm8rNmY3dXMvMlhyVU1Tekkz?=
 =?gb2312?B?Zkt2Nm1QblZOSE1FaHJHVGZjL08xUGdUK1pKbGlCZi85RVcrNHlFTXVaeEox?=
 =?gb2312?Q?5xMNY+yt6JrskU4/ZQ=3D?=
Content-Type: multipart/alternative;
	boundary="_000_SN6PR11MB3008E8AED96764C86DDC2F6C9F059SN6PR11MB3008namp_"
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c820c38b-7a43-49d9-1ac5-08d9383d58db
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2021 00:57:18.3391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +WgsT2iW/xoWQl0vCG0sGkM2dyeKlfWi+OEB9wTzDDcSryOeH6sC298AIAgEufpr+eR6BVWYWkNjNNHrAgGPzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4558
X-Proofpoint-ORIG-GUID: 4TYvoPSxp5hUHl3Y4Lm4lTmrq3FVHilI
X-Proofpoint-GUID: 4TYvoPSxp5hUHl3Y4Lm4lTmrq3FVHilI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_11:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106260003

--_000_SN6PR11MB3008E8AED96764C86DDC2F6C9F059SN6PR11MB3008namp_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGkgU3RldmUsDQoNClRoYW5rcyB2ZXJ5IG11Y2ggZm9yIHlvdXIgdmVyeSBjYXJlZnVsIGFuZCBj
bGVhciByZXBseS4gWW91ciBzdWdnZXN0aW9ucyBhcmUgdmVyeSBoZWxwZnVsLiBJIHdhcyBub3Qg
c3VyZSB3aGV0aGVyIHlvdSB3b3VsZCBhY2NlcHQgdGhlIGVuaGFuY2VtZW50IHBhdGNoIGJlZm9y
ZSwgc28gSSBmaXhlZCB0aGUgYnVnIG1vcmUgdGhvcm91Z2hseSwgd2hpY2ggaXMgcmVhbGx5IGNv
bXBsaWNhdGVkLg0KSSB3aWxsIGZvbGxvdyB5b3VyIHN1Z2dlc3Rpb25zIGFuZCByZXF1aXJlbWVu
dHMgdG8gcmVkbyB0aGUgcGF0Y2ggQVNBUC4NCg0KQmVzdCBSZWdhcmRzLA0KWXVuDQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXw0Kt6K8/sjLOiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVk
dEBnb29kbWlzLm9yZz4NCreiy83KsbzkOiAyMDIxxOo21MIyNsjVIDA6MjQNCsrVvP7IyzogWmhv
dSwgWXVuIDxZdW4uWmhvdUB3aW5kcml2ZXIuY29tPg0Ks63LzTogbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZyA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IGtlcm5lbC1oYXJkZW5p
bmdAbGlzdHMub3BlbndhbGwuY29tIDxrZXJuZWwtaGFyZGVuaW5nQGxpc3RzLm9wZW53YWxsLmNv
bT47IFh1ZSwgWWluZyA8WWluZy5YdWVAd2luZHJpdmVyLmNvbT47IExpLCBaaGlxdWFuIDxaaGlx
dWFuLkxpQHdpbmRyaXZlci5jb20+DQrW98ziOiBSZTogW1BBVENIIDEvMl0gc2VxX2J1ZjogZml4
IG92ZXJmbG93IHdoZW4gbGVuZ3RoIGlzIGJpZ2dlciB0aGFuIDgNCg0KW1BsZWFzZSBub3RlOiBU
aGlzIGUtbWFpbCBpcyBmcm9tIGFuIEVYVEVSTkFMIGUtbWFpbCBhZGRyZXNzXQ0KDQpPbiBGcmks
IDI1IEp1biAyMDIxIDIzOjUzOjQ3ICswODAwDQpZdW4gWmhvdSA8eXVuLnpob3VAd2luZHJpdmVy
LmNvbT4gd3JvdGU6DQoNCj4gVGhlcmUncyB0d28gdmFyaWFibGVzIGJlaW5nIGluY3JlYXNlZCBp
biB0aGF0IGxvb3AgKGkgYW5kIGopLCBhbmQgaQ0KPiBmb2xsb3dzIHRoZSByYXcgZGF0YSwgYW5k
IGogZm9sbG93cyB3aGF0IGlzIGJlaW5nIHdyaXR0ZW4gaW50byB0aGUgYnVmZmVyLg0KPiBXZSBz
aG91bGQgY29tcGFyZSAnaScgdG8gTUFYX01FTUhFWF9CWVRFUyBvciBjb21wYXJlICdqJyB0byBI
RVhfQ0hBUlMuDQo+IE90aGVyd2lzZSwgaWYgJ2onIGdvZXMgYmlnZ2VyIHRoYW4gSEVYX0NIQVJT
LCBpdCB3aWxsIG92ZXJmbG93IHRoZQ0KPiBkZXN0aW5hdGlvbiBidWZmZXIuDQo+DQo+IFRoaXMg
YnVnIHdhcyBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCA2ZDIyODlmM2ZhYTcxZGNjICgidHJhY2luZzog
TWFrZQ0KPiB0cmFjZV9zZXFfcHV0bWVtX2hleCgpIG1vcmUgcm9idXN0IikNCg0KTm8gaXQgd2Fz
bid0LiBUaGUgYnVnIHdhcyBpbiB0aGUgb3JpZ2luYWwgY29kZToNCg0KICA1ZTNjYTBlYzc2ZmNl
ICgiZnRyYWNlOiBpbnRyb2R1Y2UgdGhlICJoZXgiIG91dHB1dCBtZXRob2QiKQ0KDQpXaGljaCBo
YWQgdGhpczoNCg0KPiBzdGF0aWMgbm90cmFjZSBpbnQNCj4gdHJhY2Vfc2VxX3B1dG1lbV9oZXgo
c3RydWN0IHRyYWNlX3NlcSAqcywgdm9pZCAqbWVtLCBzaXplX3QgbGVuKQ0KPiB7DQo+ICAgICAg
ICAgdW5zaWduZWQgY2hhciBoZXhbSEVYX0NIQVJTXTsNCj4gICAgICAgICB1bnNpZ25lZCBjaGFy
ICpkYXRhOw0KPiAgICAgICAgIHVuc2lnbmVkIGNoYXIgYnl0ZTsNCj4gICAgICAgICBpbnQgaSwg
ajsNCj4NCj4gICAgICAgICBCVUdfT04obGVuID49IEhFWF9DSEFSUyk7DQoNCklmIGxlbiBpcyAx
NiAoYW5kIEhFWF9DSEFSUyBpcyAxNykgdGhlIGJ1ZyB3b3VsZG4ndCBoYXBwZW4uDQoNCj4NCj4g
ICAgICAgICBkYXRhID0gbWVtOw0KPg0KPiAjaWZkZWYgX19CSUdfRU5ESUFODQo+ICAgICAgICAg
Zm9yIChpID0gMCwgaiA9IDA7IGkgPCBsZW47IGkrKykgew0KPiAjZWxzZQ0KPiAgICAgICAgIGZv
ciAoaSA9IGxlbi0xLCBqID0gMDsgaSA+PSAwOyBpLS0pIHsNCj4gI2VuZGlmDQoNClRoZSBhYm92
ZSBzdGFydHMgYXQgbGVuLTEgKDE1KSBhbmQgd2lsbCBpdGVyYXRlIDE1IHRpbWVzLg0KDQo+ICAg
ICAgICAgICAgICAgICBieXRlID0gZGF0YVtpXTsNCj4NCj4gICAgICAgICAgICAgICAgIGhleFtq
XSAgID0gYnl0ZSAmIDB4MGY7DQo+ICAgICAgICAgICAgICAgICBpZiAoaGV4W2pdID49IDEwKQ0K
PiAgICAgICAgICAgICAgICAgICAgICAgICBoZXhbal0gKz0gJ2EnIC0gMTA7DQo+ICAgICAgICAg
ICAgICAgICBlbHNlDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGhleFtqXSArPSAnMCc7DQo+
ICAgICAgICAgICAgICAgICBqKys7DQo+DQo+ICAgICAgICAgICAgICAgICBoZXhbal0gPSBieXRl
ID4+IDQ7DQo+ICAgICAgICAgICAgICAgICBpZiAoaGV4W2pdID49IDEwKQ0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICBoZXhbal0gKz0gJ2EnIC0gMTA7DQo+ICAgICAgICAgICAgICAgICBlbHNl
DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGhleFtqXSArPSAnMCc7DQo+ICAgICAgICAgICAg
ICAgICBqKys7DQoNCmogaXMgaW5jcmVtZW50ZWQgdHdpY2UgZm9yIGV2ZXJ5IGxvb3AsIGFuZCBp
ZiBsZW4gd2FzIDE1LCB0aGF0IGlzIDMwIHRpbWVzLg0KDQpOZWVkbGVzcyB0byBzYXksIG9uY2Ug
aSBpdGVyYXRlZCA5IHRpbWVzLCB0aGVuIGogd291bGQgYmUgMTgsIGFuZCBvbmUNCm1vcmUgdGhh
biB0aGUgc2l6ZSBvZiBoZXguIEFuZCBib29tLCBpdCBicmVha3MuDQoNCg0KDQo+ICAgICAgICAg
fQ0KPiAgICAgICAgIGhleFtqXSA9ICcgJzsNCj4gICAgICAgICBqKys7DQo+DQo+ICAgICAgICAg
cmV0dXJuIHRyYWNlX3NlcV9wdXRtZW0ocywgaGV4LCBqKTsNCj4gfQ0KDQoNCg0KPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBZdW4gWmhvdSA8eXVuLnpob3VAd2luZHJpdmVyLmNvbT4NCj4gLS0tDQo+ICBs
aWIvc2VxX2J1Zi5jIHwgMjkgKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAt
LWdpdCBhL2xpYi9zZXFfYnVmLmMgYi9saWIvc2VxX2J1Zi5jDQo+IGluZGV4IDZhYWJiNjA5ZGQ4
Ny4uYWEyZjY2NmU1ODRlIDEwMDY0NA0KPiAtLS0gYS9saWIvc2VxX2J1Zi5jDQo+ICsrKyBiL2xp
Yi9zZXFfYnVmLmMNCj4gQEAgLTIxMCw3ICsyMTAsOCBAQCBpbnQgc2VxX2J1Zl9wdXRtZW0oc3Ry
dWN0IHNlcV9idWYgKnMsIGNvbnN0IHZvaWQgKm1lbSwgdW5zaWduZWQgaW50IGxlbikNCj4gICAq
IHNlcV9idWZfcHV0bWVtX2hleCAtIHdyaXRlIHJhdyBtZW1vcnkgaW50byB0aGUgYnVmZmVyIGlu
IEFTQ0lJIGhleA0KPiAgICogQHM6IHNlcV9idWYgZGVzY3JpcHRvcg0KPiAgICogQG1lbTogVGhl
IHJhdyBtZW1vcnkgdG8gd3JpdGUgaXRzIGhleCBBU0NJSSByZXByZXNlbnRhdGlvbiBvZg0KPiAt
ICogQGxlbjogVGhlIGxlbmd0aCBvZiB0aGUgcmF3IG1lbW9yeSB0byBjb3B5IChpbiBieXRlcykN
Cj4gKyAqIEBsZW46IFRoZSBsZW5ndGggb2YgdGhlIHJhdyBtZW1vcnkgdG8gY29weSAoaW4gYnl0
ZXMpLg0KPiArICogICAgICAgSXQgY2FuIGJlIG5vdCBsYXJnZXIgdGhhbiA4Lg0KPiAgICoNCj4g
ICAqIFRoaXMgaXMgc2ltaWxhciB0byBzZXFfYnVmX3B1dG1lbSgpIGV4Y2VwdCBpbnN0ZWFkIG9m
IGp1c3QgY29weWluZyB0aGUNCj4gICAqIHJhdyBtZW1vcnkgaW50byB0aGUgYnVmZmVyIGl0IHdy
aXRlcyBpdHMgQVNDSUkgcmVwcmVzZW50YXRpb24gb2YgaXQNCj4gQEAgLTIyOCwyNyArMjI5LDE5
IEBAIGludCBzZXFfYnVmX3B1dG1lbV9oZXgoc3RydWN0IHNlcV9idWYgKnMsIGNvbnN0IHZvaWQg
Km1lbSwNCj4NCj4gICAgICAgV0FSTl9PTihzLT5zaXplID09IDApOw0KPg0KPiAtICAgICB3aGls
ZSAobGVuKSB7DQo+IC0gICAgICAgICAgICAgc3RhcnRfbGVuID0gbWluKGxlbiwgSEVYX0NIQVJT
IC0gMSk7DQo+ICsgICAgIHN0YXJ0X2xlbiA9IG1pbihsZW4sIE1BWF9NRU1IRVhfQllURVMpOw0K
PiAgI2lmZGVmIF9fQklHX0VORElBTg0KPiAtICAgICAgICAgICAgIGZvciAoaSA9IDAsIGogPSAw
OyBpIDwgc3RhcnRfbGVuOyBpKyspIHsNCj4gKyAgICAgZm9yIChpID0gMCwgaiA9IDA7IGkgPCBz
dGFydF9sZW47IGkrKykgew0KPiAgI2Vsc2UNCj4gLSAgICAgICAgICAgICBmb3IgKGkgPSBzdGFy
dF9sZW4tMSwgaiA9IDA7IGkgPj0gMDsgaS0tKSB7DQo+ICsgICAgIGZvciAoaSA9IHN0YXJ0X2xl
bi0xLCBqID0gMDsgaSA+PSAwOyBpLS0pIHsNCj4gICNlbmRpZg0KPiAtICAgICAgICAgICAgICAg
ICAgICAgaGV4W2orK10gPSBoZXhfYXNjX2hpKGRhdGFbaV0pOw0KPiAtICAgICAgICAgICAgICAg
ICAgICAgaGV4W2orK10gPSBoZXhfYXNjX2xvKGRhdGFbaV0pOw0KPiAtICAgICAgICAgICAgIH0N
Cj4gLSAgICAgICAgICAgICBpZiAoV0FSTl9PTl9PTkNFKGogPT0gMCB8fCBqLzIgPiBsZW4pKQ0K
PiAtICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+IC0NCj4gLSAgICAgICAgICAgICAvKiBq
IGluY3JlbWVudHMgdHdpY2UgcGVyIGxvb3AgKi8NCj4gLSAgICAgICAgICAgICBsZW4gLT0gaiAv
IDI7DQo+IC0gICAgICAgICAgICAgaGV4W2orK10gPSAnICc7DQo+IC0NCj4gLSAgICAgICAgICAg
ICBzZXFfYnVmX3B1dG1lbShzLCBoZXgsIGopOw0KPiAtICAgICAgICAgICAgIGlmIChzZXFfYnVm
X2hhc19vdmVyZmxvd2VkKHMpKQ0KPiAtICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC0xOw0K
PiArICAgICAgICAgICAgIGhleFtqKytdID0gaGV4X2FzY19oaShkYXRhW2ldKTsNCj4gKyAgICAg
ICAgICAgICBoZXhbaisrXSA9IGhleF9hc2NfbG8oZGF0YVtpXSk7DQo+ICAgICAgIH0NCj4gKw0K
PiArICAgICBzZXFfYnVmX3B1dG1lbShzLCBoZXgsIGopOw0KPiArICAgICBpZiAoc2VxX2J1Zl9o
YXNfb3ZlcmZsb3dlZChzKSkNCj4gKyAgICAgICAgICAgICByZXR1cm4gLTE7DQo+ICAgICAgIHJl
dHVybiAwOw0KPiAgfQ0KPg0KDQpUaGUgYWJvdmUgaXMgKndheSogdG9vIGNvbXBsZXggZm9yIGEg
YmFja3BvcnQgdGhhdCBzaG91bGQgZ28gYmFjayB0bw0KdGhlIGJlZ2lubmluZy4gWW91IHdlcmUg
cGFydGlhbGx5LCBjb3JyZWN0LCBhbmQgdGhlIHByb3BlciBmaXggd291bGQgYmU6DQoNCg0KZGlm
ZiAtLWdpdCBhL2xpYi9zZXFfYnVmLmMgYi9saWIvc2VxX2J1Zi5jDQppbmRleCA3MDc0NTNmNWQ1
OGUuLmViNjhiNWIzZWIyNiAxMDA2NDQNCi0tLSBhL2xpYi9zZXFfYnVmLmMNCisrKyBiL2xpYi9z
ZXFfYnVmLmMNCkBAIC0yMjksOCArMjI5LDEwIEBAIGludCBzZXFfYnVmX3B1dG1lbV9oZXgoc3Ry
dWN0IHNlcV9idWYgKnMsIGNvbnN0IHZvaWQgKm1lbSwNCg0KICAgICAgICBXQVJOX09OKHMtPnNp
emUgPT0gMCk7DQoNCisgICAgICAgQlVJTERfQlVHX09OKE1BWF9NRU1IRVhfQllURVMgKiAyID49
IEhFWF9DSEFSUyk7DQorDQogICAgICAgIHdoaWxlIChsZW4pIHsNCi0gICAgICAgICAgICAgICBz
dGFydF9sZW4gPSBtaW4obGVuLCBIRVhfQ0hBUlMgLSAxKTsNCisgICAgICAgICAgICAgICBzdGFy
dF9sZW4gPSBtaW4obGVuLCBNQVhfTUVNSEVYX0JZVEVTIC0gMSk7DQogI2lmZGVmIF9fQklHX0VO
RElBTg0KICAgICAgICAgICAgICAgIGZvciAoaSA9IDAsIGogPSAwOyBpIDwgc3RhcnRfbGVuOyBp
KyspIHsNCiAjZWxzZQ0KLS0NCjIuMjkuMg0KDQoNClRoYXQgc29sdmVzIHRoZSBmaXJzdCBidWcs
IGFuZCBpcyBlYXN5IHRvIGJhY2twb3J0Lg0KDQpUaGUgc2Vjb25kIGJ1ZywgaXMgdGhhdCBkYXRh
IGRvZXNuJ3QgZ28gZm9yd2FyZCAoYXMgeW91IHN0YXRlZCBpbiB5b3VyDQpvcmlnaW5hbCBwYXRj
aCkgd2hpY2ggd291bGQgYmU6DQoNCmRpZmYgLS1naXQgYS9saWIvc2VxX2J1Zi5jIGIvbGliL3Nl
cV9idWYuYw0KaW5kZXggZWI2OGI1YjNlYjI2Li4zOWI5Mzc0ZDNhMWUgMTAwNjQ0DQotLS0gYS9s
aWIvc2VxX2J1Zi5jDQorKysgYi9saWIvc2VxX2J1Zi5jDQpAQCAtMjQ0LDEzICsyNDQsMTQgQEAg
aW50IHNlcV9idWZfcHV0bWVtX2hleChzdHJ1Y3Qgc2VxX2J1ZiAqcywgY29uc3Qgdm9pZCAqbWVt
LA0KICAgICAgICAgICAgICAgIGlmIChXQVJOX09OX09OQ0UoaiA9PSAwIHx8IGovMiA+IGxlbikp
DQogICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCg0KLSAgICAgICAgICAgICAgIC8qIGog
aW5jcmVtZW50cyB0d2ljZSBwZXIgbG9vcCAqLw0KLSAgICAgICAgICAgICAgIGxlbiAtPSBqIC8g
MjsNCiAgICAgICAgICAgICAgICBoZXhbaisrXSA9ICcgJzsNCg0KICAgICAgICAgICAgICAgIHNl
cV9idWZfcHV0bWVtKHMsIGhleCwgaik7DQogICAgICAgICAgICAgICAgaWYgKHNlcV9idWZfaGFz
X292ZXJmbG93ZWQocykpDQogICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLTE7DQorDQor
ICAgICAgICAgICAgICAgbGVuIC09IHN0YXJ0X2xlbjsNCisgICAgICAgICAgICAgICBkYXRhICs9
IHN0YXJ0X2xlbjsNCiAgICAgICAgfQ0KICAgICAgICByZXR1cm4gMDsNCiB9DQoNCldoeSBhcmUg
eW91IG1ha2luZyBpdCBzbyBjb21wbGljYXRlZD8NCg0KLS0gU3RldmUNCg==

--_000_SN6PR11MB3008E8AED96764C86DDC2F6C9F059SN6PR11MB3008namp_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Hi Steve,</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Thanks very much for your very careful and clear reply. Your suggestions ar=
e very helpful. I was not sure whether you would accept the enhancement pat=
ch before, so I fixed the bug more thoroughly, which is really complicated.=
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
I will follow&nbsp;<span style=3D"background-color:rgb(255, 255, 255);displ=
ay:inline !important">your suggestions and requirements to&nbsp;</span>redo=
 the patch ASAP.</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Best Regards,</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Yun</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>=B7=A2=BC=FE=C8=CB:</b> Steven =
Rostedt &lt;rostedt@goodmis.org&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2021=C4=EA6=D4=C226=C8=D5 0:24<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Zhou, Yun &lt;Yun.Zhou@windriver.com&gt;<br>
<b>=B3=AD=CB=CD:</b> linux-kernel@vger.kernel.org &lt;linux-kernel@vger.ker=
nel.org&gt;; kernel-hardening@lists.openwall.com &lt;kernel-hardening@lists=
.openwall.com&gt;; Xue, Ying &lt;Ying.Xue@windriver.com&gt;; Li, Zhiquan &l=
t;Zhiquan.Li@windriver.com&gt;<br>
<b>=D6=F7=CC=E2:</b> Re: [PATCH 1/2] seq_buf: fix overflow when length is b=
igger than 8</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">[Please note: This e-mail is from an EXTERNAL e-ma=
il address]<br>
<br>
On Fri, 25 Jun 2021 23:53:47 +0800<br>
Yun Zhou &lt;yun.zhou@windriver.com&gt; wrote:<br>
<br>
&gt; There's two variables being increased in that loop (i and j), and i<br=
>
&gt; follows the raw data, and j follows what is being written into the buf=
fer.<br>
&gt; We should compare 'i' to MAX_MEMHEX_BYTES or compare 'j' to HEX_CHARS.=
<br>
&gt; Otherwise, if 'j' goes bigger than HEX_CHARS, it will overflow the<br>
&gt; destination buffer.<br>
&gt;<br>
&gt; This bug was introduced by commit 6d2289f3faa71dcc (&quot;tracing: Mak=
e<br>
&gt; trace_seq_putmem_hex() more robust&quot;)<br>
<br>
No it wasn't. The bug was in the original code:<br>
<br>
&nbsp; 5e3ca0ec76fce (&quot;ftrace: introduce the &quot;hex&quot; output me=
thod&quot;)<br>
<br>
Which had this:<br>
<br>
&gt; static notrace int<br>
&gt; trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)<br>
&gt; {<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned char hex[HEX_=
CHARS];<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned char *data;<b=
r>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned char byte;<br=
>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int i, j;<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUG_ON(len &gt;=3D HEX=
_CHARS);<br>
<br>
If len is 16 (and HEX_CHARS is 17) the bug wouldn't happen.<br>
<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; data =3D mem;<br>
&gt;<br>
&gt; #ifdef __BIG_ENDIAN<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0, j =3D 0;=
 i &lt; len; i++) {<br>
&gt; #else<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D len-1, j =
=3D 0; i &gt;=3D 0; i--) {<br>
&gt; #endif<br>
<br>
The above starts at len-1 (15) and will iterate 15 times.<br>
<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; byte =3D data[i];<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; hex[j]&nbsp;&nbsp; =3D byte &amp; 0x0f;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; if (hex[j] &gt;=3D 10)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; h=
ex[j] +=3D 'a' - 10;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; else<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; h=
ex[j] +=3D '0';<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; j++;<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; hex[j] =3D byte &gt;&gt; 4;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; if (hex[j] &gt;=3D 10)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; h=
ex[j] +=3D 'a' - 10;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; else<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; h=
ex[j] +=3D '0';<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; j++;<br>
<br>
j is incremented twice for every loop, and if len was 15, that is 30 times.=
<br>
<br>
Needless to say, once i iterated 9 times, then j would be 18, and one<br>
more than the size of hex. And boom, it breaks.<br>
<br>
<br>
<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hex[j] =3D ' ';<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; j++;<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return trace_seq_putme=
m(s, hex, j);<br>
&gt; }<br>
<br>
<br>
<br>
&gt;<br>
&gt; Signed-off-by: Yun Zhou &lt;yun.zhou@windriver.com&gt;<br>
&gt; ---<br>
&gt;&nbsp; lib/seq_buf.c | 29 +++++++++++------------------<br>
&gt;&nbsp; 1 file changed, 11 insertions(+), 18 deletions(-)<br>
&gt;<br>
&gt; diff --git a/lib/seq_buf.c b/lib/seq_buf.c<br>
&gt; index 6aabb609dd87..aa2f666e584e 100644<br>
&gt; --- a/lib/seq_buf.c<br>
&gt; +++ b/lib/seq_buf.c<br>
&gt; @@ -210,7 +210,8 @@ int seq_buf_putmem(struct seq_buf *s, const void *=
mem, unsigned int len)<br>
&gt;&nbsp;&nbsp; * seq_buf_putmem_hex - write raw memory into the buffer in=
 ASCII hex<br>
&gt;&nbsp;&nbsp; * @s: seq_buf descriptor<br>
&gt;&nbsp;&nbsp; * @mem: The raw memory to write its hex ASCII representati=
on of<br>
&gt; - * @len: The length of the raw memory to copy (in bytes)<br>
&gt; + * @len: The length of the raw memory to copy (in bytes).<br>
&gt; + *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; It can be not larger than 8.<b=
r>
&gt;&nbsp;&nbsp; *<br>
&gt;&nbsp;&nbsp; * This is similar to seq_buf_putmem() except instead of ju=
st copying the<br>
&gt;&nbsp;&nbsp; * raw memory into the buffer it writes its ASCII represent=
ation of it<br>
&gt; @@ -228,27 +229,19 @@ int seq_buf_putmem_hex(struct seq_buf *s, const =
void *mem,<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WARN_ON(s-&gt;size =3D=3D 0);<br>
&gt;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp; while (len) {<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; start_len =3D min(len, HEX_CHARS - 1);<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp; start_len =3D min(len, MAX_MEMHEX_BYTES);<br=
>
&gt;&nbsp; #ifdef __BIG_ENDIAN<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; for (i =3D 0, j =3D 0; i &lt; start_len; i++) {<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D 0, j =3D 0; i &lt; start_len; i++=
) {<br>
&gt;&nbsp; #else<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; for (i =3D start_len-1, j =3D 0; i &gt;=3D 0; i--) {<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp; for (i =3D start_len-1, j =3D 0; i &gt;=3D 0=
; i--) {<br>
&gt;&nbsp; #endif<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hex[j++] =3D hex_asc_hi=
(data[i]);<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hex[j++] =3D hex_asc_lo=
(data[i]);<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; }<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; if (WARN_ON_ONCE(j =3D=3D 0 || j/2 &gt; len))<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<br>
&gt; -<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; /* j increments twice per loop */<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; len -=3D j / 2;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; hex[j++] =3D ' ';<br>
&gt; -<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; seq_buf_putmem(s, hex, j);<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; if (seq_buf_has_overflowed(s))<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -1;<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; hex[j++] =3D hex_asc_hi(data[i]);<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; hex[j++] =3D hex_asc_lo(data[i]);<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&gt; +<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp; seq_buf_putmem(s, hex, j);<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp; if (seq_buf_has_overflowed(s))<br>
&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; return -1;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>
&gt;&nbsp; }<br>
&gt;<br>
<br>
The above is *way* too complex for a backport that should go back to<br>
the beginning. You were partially, correct, and the proper fix would be:<br=
>
<br>
<br>
diff --git a/lib/seq_buf.c b/lib/seq_buf.c<br>
index 707453f5d58e..eb68b5b3eb26 100644<br>
--- a/lib/seq_buf.c<br>
+++ b/lib/seq_buf.c<br>
@@ -229,8 +229,10 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *=
mem,<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WARN_ON(s-&gt;size =3D=3D 0);<br=
>
<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUILD_BUG_ON(MAX_MEMHEX_BYTES * 2 &gt=
;=3D HEX_CHARS);<br>
+<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (len) {<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; start_len =3D min(len, HEX_CHARS - 1);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; start_len =3D min(len, MAX_MEMHEX_BYTES - 1);<br>
&nbsp;#ifdef __BIG_ENDIAN<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; for (i =3D 0, j =3D 0; i &lt; start_len; i++) {<br>
&nbsp;#else<br>
--<br>
2.29.2<br>
<br>
<br>
That solves the first bug, and is easy to backport.<br>
<br>
The second bug, is that data doesn't go forward (as you stated in your<br>
original patch) which would be:<br>
<br>
diff --git a/lib/seq_buf.c b/lib/seq_buf.c<br>
index eb68b5b3eb26..39b9374d3a1e 100644<br>
--- a/lib/seq_buf.c<br>
+++ b/lib/seq_buf.c<br>
@@ -244,13 +244,14 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void =
*mem,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; if (WARN_ON_ONCE(j =3D=3D 0 || j/2 &gt; len))<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;<br>
<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; /* j increments twice per loop */<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; len -=3D j / 2;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; hex[j++] =3D ' ';<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; seq_buf_putmem(s, hex, j);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; if (seq_buf_has_overflowed(s))<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return -1;<=
br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; len -=3D start_len;<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; data +=3D start_len;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;<br>
&nbsp;}<br>
<br>
Why are you making it so complicated?<br>
<br>
-- Steve<br>
</div>
</span></font></div>
</body>
</html>

--_000_SN6PR11MB3008E8AED96764C86DDC2F6C9F059SN6PR11MB3008namp_--
