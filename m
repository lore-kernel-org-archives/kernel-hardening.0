Return-Path: <kernel-hardening-return-21924-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 70593C02185
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2025 17:45:04 +0000 (UTC)
Received: (qmail 11756 invoked by uid 550); 20 Jan 2025 17:44:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5689 invoked from network); 20 Jan 2025 17:16:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737393389; x=1768929389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WMH4ev7SWMa4YjGD9A/VcK+UEI973uQ+HoBtnemm5+o=;
  b=pDw5FaxxenJQkmIt8IlivvIvV9LFkXfgXuGxm+mxlt5YLXZHPjhELf6/
   54suaP7GhKxdq5pmbyoZKaUFApIwX5MpV0XqfuhCeKpd6PATJ5QUJB2Wx
   DOpj25RIZ/GeqzSU8Cxq6h39yyzXuvrcLgEfeVSesSwYdPXolC+4ogiQb
   9e4gfMBezq2z6NzaXfvyPeoTvLrclouGjriSN/FVPZYh9KwgCz7pMcp8Z
   29vkRJmQSrAi+1DX0SalG66qx+LX0Sj716n1IkPI2FPTJgNb9VfQaTx1N
   6HrY+qbqE036KLs/Txn+Gwh8/oaWmAbwkBuWhptGLUvVcN9rG6Z+kGu5p
   w==;
X-CSE-ConnectionGUID: 9M7yK1VNTN651envalTvWg==
X-CSE-MsgGUID: xeaR2MLaTfi0rhno/o0ogg==
X-IronPort-AV: E=Sophos;i="6.13,219,1732550400"; 
   d="scan'208";a="36360609"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAIFBZ2VHeyWXTb1+KdegDF92vf0iD2nnRb7aE9g1O5PM5KxPUcMDPX5xFgrodwsh52wRyO99I3zwQMV2ksNDNodArRkmMgYSpT1l7cEx3N89VFDQOY0fJJ1qj9EVjMO7sBJoEPfpHzlUYXefQ4va0lmXKeQ5oFNkt7u7OWVgKCpSv7EWHSgcgs+Qd1zIwGAMkAZFv5m/gr2THuPMA5VJG0VUaqqw6ljN/ZSaYimhbppD5+RuneGD5JL1puRBEKmvSghzm8ftb7JZE7NhDSJrYOSfpdd+6vgeBJU968t8d/tcsI2guWVmzP8lCSeo9IPUPx3FARPuqev7trOdZB6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMH4ev7SWMa4YjGD9A/VcK+UEI973uQ+HoBtnemm5+o=;
 b=Cp8CL4owCkXO7KGlJ15NIvU7XjixbQvTumxHJFuYWOm2fJrV4rg1VYUB+LebF+N9li253+8VGxsXp73TMgSB3tX+cmwZ7ShUs2DoFH4EkcTY2DKAoe9Y08/BhCLZkgK5Kom0by5eBVtMY14OauBID4eJ9E+ekf8Ptt7VOigfDfSkZMVf92C5GkYlV+k5mb0QHj5xdURI10/7Wl2LPddyU/cKL2j/M/IH1PpVTZqwvESZEpup40wZV5uLkRZnVkQRIf4Hg+nTbNXmafKJ4P38TX3mZNRVzyQA8waory1tuetJbzXrcRadlItZk5UpA4aPBzVqlR42IL0BhLE3bMtvPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMH4ev7SWMa4YjGD9A/VcK+UEI973uQ+HoBtnemm5+o=;
 b=KX/njsFH/g1f9bti4jjKRTdIAA+MaNCk7m9AU9uqDiMMDxPJJKZBK4to7EyXIYfh8vr6cSTtrcOlInnVPemXYbtidabv5XaoVOCJlGgSQtBQGH82l2KGCtbpYnlpL6on5VsijnJC2Y0y3wwc2cWtbiu3XvsHhwQ0B/wZdqIG1kk=
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Ethan Carter Edwards <ethan@ethancedwards.com>, "manoj@linux.ibm.com"
	<manoj@linux.ibm.com>
CC: "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	Uma Krishnan <ukrishn@linux.ibm.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro
	<viro@zeniv.linux.org.uk>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: cxlflash: change kzalloc to kcalloc
Thread-Topic: [PATCH] scsi: cxlflash: change kzalloc to kcalloc
Thread-Index: AQHba1wUNaWu79V38k69TpfooG8OzrMf50kA
Date: Mon, 20 Jan 2025 17:16:13 +0000
Message-ID: <17cbbae6-0b05-4ea3-af04-4db43c40654a@wdc.com>
References: <20250120165411.32256-1-ethan@ethancedwards.com>
In-Reply-To: <20250120165411.32256-1-ethan@ethancedwards.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6588:EE_
x-ms-office365-filtering-correlation-id: e4aa3de9-5955-4e13-facb-08dd3976243a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?K3ZWU2poa1BpOC9SRE51TTQwblhXMWlxNE1mUXJIajd5R3RqMy9WcExZbnFz?=
 =?utf-8?B?TVJjc0dQeGtwMUx6ZWdqZE5rZTN0Z1FEWWpGOENYa1dMdE5qUWpUL1Y3b3pH?=
 =?utf-8?B?bUhZblIxUkdwK2xoS015emVPNkVXWGZlOTJyUVJLaFg5d3V3TnhwU1c3ckR4?=
 =?utf-8?B?c3BCNjBpdVNyd1dmWVh0TlFudjA5Q1orb0hxVCt6M2hoZnVIOS9HUnpaYnJs?=
 =?utf-8?B?aS83bndqTks5Kzh2S0ZnNXFDZ1JHT1lidEFkckNjSWFTTklyU3c5OUNHMUtU?=
 =?utf-8?B?cXh6Z0JzM1YwN0FIcEJFb3ZRUVNxbVIzOFo1T2lhbFpXQnY4Q3FXSi9MMFAv?=
 =?utf-8?B?bGoyaG4yWUZwWFdCSWRIT0NNcTgxSXNLT2M0ZS93elpSSzREQUpabmFPVEFP?=
 =?utf-8?B?bEpMUThHWGd5dUtkdktibEIzUGZDVUw3OUZnY2Zadmx0dGJkLzcyOXpwTVV2?=
 =?utf-8?B?b09TcUliUmlHS3RXd2ozQnFmdFZ5SG5IVHZUd293YU56VllTTU5vbUZ2THdC?=
 =?utf-8?B?bTJKb3FJekF2OFdCMlF3b2hjOU1qY0VCNHNoQzIvZnpYNmtGTVh6L1BsdlJh?=
 =?utf-8?B?b0t1RDRRLzVMcUJiUzZsSjhjeURyem5HNDNxVFJ5dGZBeitLbW1oOWNIWld5?=
 =?utf-8?B?MlhmV2xRelhjWTk2RXU1RVIveFFGVWJ4cDdLV0RSblBpdTZ2RnhGMExoSk8z?=
 =?utf-8?B?RlJJWVBZV2hxVTQ1ME93RndMSnJPQ3NUaUFrTkI1UmM3UDdFbHBCSElaakx2?=
 =?utf-8?B?UmR3djFLMmQyVW5uRTVCaGovMXluREhBODdZYU9mcTdHYnRVaUFkU1VsZUkv?=
 =?utf-8?B?YmpaOTh4elBuTGRNQ1NqVzRWNmQ4MFFOdys5QWFLSVhrdk1sa3RxblNlK1Nj?=
 =?utf-8?B?dVNra3BVY0Q3Tm1hRDh1cVhIZElKZVVFV0NKemx5RE01ZHd1RlU2WG1WL0JV?=
 =?utf-8?B?SmQyNnJRK3o0OWtLd0RXMmpOSm0zVFlTekVVK3RMdEh6d3AxaWVFTnY2Y3lw?=
 =?utf-8?B?c0MwVjBFd2Z6eGd1dndueEM5WlpEeDlTOUZjblNJWkhpcXdvcVJtMkhFUlZo?=
 =?utf-8?B?OWFCbXFLMVlod21Da3pBUmZoN3N6QVhkamZVVGFLL2pMaE5BR2YwVy8yWUFj?=
 =?utf-8?B?aHZpUnhuOFh5MExmNXhBRXBPTGZkWWcxblFURDJYK2FWZDlJMXRYaUdZQ0Yr?=
 =?utf-8?B?Y3FjTUVod1RUQ1p3SW43QmYwTXNtZEtKUlYzbHJ1SjRtRCtZQ2dJVEQveHI0?=
 =?utf-8?B?TjVBMWEzZjdieDhtclQyZ3dUYURBUk1yeFppRDJacng2VElvYVNwSGorcFk3?=
 =?utf-8?B?c0hKRHBWbVU5QzJweHRsUkVBSDdwZWIzUXg2UWRyWFNFdWdUeTJjNnE1RDZq?=
 =?utf-8?B?Mk5IcmY4eGc3MUY2M1ZYemhnNktMclkvSmFpVDZzN2FBVHB0SzMxcUFBOG1x?=
 =?utf-8?B?Y2FwS0syR2Z0c3Y3UldqWkQ5T1h2NTBZYnJUZ3FBRmpoRk1jQzlST2pSRTl6?=
 =?utf-8?B?WW9xMDNHdU1oZm1mVXZtWUgveWllOExjdWVyeU8yZXQ1a1dTY1grb1p1VCsr?=
 =?utf-8?B?cEs3MU5FUis4bzk3MkNaN0ZrT1djMFB0NE9wbWRFZllIbUdxb3FVeU1IS0lY?=
 =?utf-8?B?VzNuMkFSaWEzVWZ6YUdmSWlTSzloZkl6VmZ6K1YrWFBmbXBCbmEwbHhSNEdQ?=
 =?utf-8?B?Q2t6KzJsQXdLZzNFMGg4MnNyZkFmbDFOUnl5cFpva1NjNHpWSjhDMHh4RVND?=
 =?utf-8?B?dDBuQVRmSGR0VzJIS1FGL3ZiVUFGcjlVbG5KWmUwSDhkbFYyODRpT0phcGpQ?=
 =?utf-8?B?SS9rcllxd3dQVkFPV3U2dFFVanhaZTlyb1JmSFZKMTl6bURqcWRENXNBOXhu?=
 =?utf-8?B?bWxLQTZmZlR5V0dqWVNERDRDQS9uZVBabVZtd004V3JaWGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eGYxNlZqZm5Qdm5PYUp2bVF0RTlXcVJkQytlSEZ2anByWlJVRUFBRytVc0Qx?=
 =?utf-8?B?R2FRTkoybURKWXcyR1dXQVVhaFJzbWEzSHI2bDR5SFJCaUFib1hKUWR0YnJp?=
 =?utf-8?B?VVdMUmdPZFpaY1d6VWRhV0xHRVJMaVo1U1UxaVF2dlpBTU9CbG9JNXU0eFl1?=
 =?utf-8?B?ZFV4aitNU3g4OUFGenFmT2NuUXJaTkNacit6bmpoN3JDRzE4TjA2OUJYN3Jp?=
 =?utf-8?B?cGk3K0xtUWN4dTl4Q2tMckk1MnoyUm50QXc5QTMzeE11VDJVa3dEaHd4SERN?=
 =?utf-8?B?b050VUsyZ0VpOFQxa1oxUlRJaDNuc3JTaktLVlFEd3RKSHFvZlVHbFlUcHYr?=
 =?utf-8?B?WWJqN1FsVXJEOEI2dTF3czJmR3pmeUtDTTZQeVlNbTJkUG0xWHJaRThUb2Zv?=
 =?utf-8?B?S2VVT0djNXNnOHNaQUpQc3Y0MHB4cFptUU9ibnRQMmJTUkVQU0E1MzBVUWtP?=
 =?utf-8?B?WGpnQWdXQTJTNC85WjZhSlJzdVFYcHN0OUg1bkwzUFZ4MFdrcXdsbVhEL2pD?=
 =?utf-8?B?VVBUaXJhZ2c5ODQ5eEhrbnM5RlVLaDNhcmZwK2c4K3p2RDdDME1YUFFIcjhq?=
 =?utf-8?B?MjZsM0hxckZhWGEvQTZ0UkJzc3BDVmJYcHRGV3Y4K0hna3JlWm8xL2xRbkxV?=
 =?utf-8?B?eEFGWDBLUUg0SUVFRy9DOXZpYWpjM0s4YkJJZmJRN2JZNFJ5SC94OTZPSEF1?=
 =?utf-8?B?b2xLYXA1aUJtTGt2Ums4a290aktYK0lXcTdRL01PR1pYOCtVRUJrVFR0RVhE?=
 =?utf-8?B?ckUxc1pydW1ZUWlsTHhGOG95bW81U0NUSEVPNTVvS20wZTZ5S1l0UWllMVVR?=
 =?utf-8?B?L1BqSUJVS0NHaElXQU5yWDJTN2xxTHJNQ3F4Ulp3dnJaQzNFNTVJZlQzWEZU?=
 =?utf-8?B?Q1YzKytjU0hlQzZEM1hTWTJJWDFlQUFCQ2lWWVg2VXMwQ2MxdG1PK0hMTGtZ?=
 =?utf-8?B?UmcxOWJ2SkFRWU9RNkJLZ1gvbWt4bVBNN0MrT3VKMnhianluSDZTVXc1NVJR?=
 =?utf-8?B?bzFDOW1valAwdUdaeEJ3b3FCd2dtc1FJSnJWSVpFelBoekswQmNXbllPMGI0?=
 =?utf-8?B?T3BTQytBbTRGSUovWldnaEZNOXhIbTBtTGpwZkRUOStMQ0Z6eU8rYzJiRDFs?=
 =?utf-8?B?NHRwZHBocjd0TjNFU0M1WVpGZUt5NmdPY0lSOEVodG15d0FEU09JVlNJRGhX?=
 =?utf-8?B?YUhLd0IxNUpBRHhTc1NObmhrUDUxcUd0VHYxUjVaVW0rMURQTmdqVEFheGtj?=
 =?utf-8?B?WWJpOWtkVDBEUjYzRUFXZ0lzdGJTaGZ1M0h4S3NPYUJReWkyR2duWE5qYTZG?=
 =?utf-8?B?TmdwczJ3QWZBSFdHcFlzZnliUU5YM1NZa003TlN6Ym14OGI0djUxTXd4a2RO?=
 =?utf-8?B?NUN6eDhFakxXdHZkSHJBMkFXTnVCMEVuVVpCamhxRnkwUHBxTzZlOU5SOUZk?=
 =?utf-8?B?blQ0dlBkNGszbzZvOUJoRWlwcVdEbGo3Q1l5NzVnTlkrbWx5bU9RWG94Znpv?=
 =?utf-8?B?SmpoQnc1TGN0THpxK21MQSt2ZEJpNWh0SGtXS3RwL1lTK00rVGdXOVQxM2lx?=
 =?utf-8?B?RkFhRXpEZXhyeXFybHROcitNZzBQTlp3cy9QWnpIRkVETGNObFRkS0VNZ21i?=
 =?utf-8?B?eVBNQmdSUEpGdHhHYkx0VVpYazArYVE4NlorSDk1d2g1bjBYQTBzNlkzQzVJ?=
 =?utf-8?B?TTNhOGlvTG1lYnhHeG1tNEUySnN1dlhTUkx2V0tSNXNJQU1YVkRVNDd4em5E?=
 =?utf-8?B?NVRDVlJaU2paU2lIKzYvbTMwdFlDc3dlalRMNFNvUmFoWE1YY2xPeFpPUndo?=
 =?utf-8?B?Z1lVa2NhR093TFlNY1l6QzFtSzBUVXRuN1BMVXdNam51WGdtTUZQTjlaa2hx?=
 =?utf-8?B?SXFENFl6ZEhBT2ZwV2pWTHpLVFMxTW5sMGpua0FwSVVvK1FONmY2ZlpoOUtt?=
 =?utf-8?B?ZGtUT3ZDeWl2N3liVWdqdUsvYTdBaEZqMmYrbDJ1Q2hFK2ZVYldCRHhCUnUr?=
 =?utf-8?B?d2lISVNxS2tPNFozaTZxTmg1SmZsRHA2d1Z6V0I4bkZ1c1VrY2dsb3J4dVg1?=
 =?utf-8?B?YkRsWXlZakJza0ViRzdhNHZhNHFCMVhzMWFaMkx4dGpDWCtPd2c4Yk44WFdW?=
 =?utf-8?B?eDEwVEhmMytvcS9DK1RTclFWUjNUeWliSC84alhacUhoOWRXMlhrbFJTNFRR?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC05B46B811B1145849099CC9F7988C9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Daw0oDg7/aD9p2zfW3eXzMaPyPEAoNCgezH3noeLUdDfLyQShr3myOT++Lp1gsDSczcU6p4e36QPycRrSoYOKlTVFS4GpH3YdRQBxi00Y1NlQHEyhTTGTiYhb6cTGrcckIVyYKM7dqbyWnahK6lZRv2mlBYM9iu+LMwPJ7+BuciD1F/BqC5Pdpiz+rqfpR+OQbKYZl7g+ViAlvdhjToelvYTeN08tYaO5r4iiftYH2xrq6SjgZ8QLnLjDIDPR/MoQdyIPJ/pOeVx0NTEh6sf6L9sDwAOYuugM1llk5MC+gwmNckOg4tEM2eqfP3tTJwYpB21LRDa5b4STrdWWEsKWnxLAWRgUldwRzToKPgC7u0uKpNUaT+Ier+UwYuA+omuBokuabnujzQMvtx2liTvzudIOr+0/vJWPfMDe2wctVmHQzRSYNs9wpuOm/unjLICaV3Y4UgUW+McBjwtDuE/s4K6r9uMdsFMHc1eXGEGizEi3mpA0JrVBU/rqoVKiabAwoQIw9IVbvtaqMosq7DM6vB1lSHnLHX9oORgC8AcVxtkTJ1EqnZJwGROgI45mcNabtpt1+mgiP2HMrWEQiKtwPMKabkg1gMoXcEtlxy0Czs+RhHUgKPJBzMT0Rop3DNh
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4aa3de9-5955-4e13-facb-08dd3976243a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 17:16:13.3025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oRsP744KMqWmxtRaxtuT+H2WE0yb3o/VwLaRqPPWVersg/hZ0LtAd0iwe0YkpeWDqi10QF2dfrX6y4zWUYnDKHGXytLInq1p9vHUGEHFYfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6588

T24gMjAuMDEuMjUgMTc6NTUsIEV0aGFuIENhcnRlciBFZHdhcmRzIHdyb3RlOg0KPiBXZSBhcmUg
cmVwbGFjaW5nIGFueSBpbnN0YW5jZXMgb2Yga3phbGxvYyhzaXplICogY291bnQsIC4uLikgd2l0
aA0KPiBrY2FsbG9jKGNvdW50LCBzaXplLCAuLi4pIGR1ZSB0byByaXNrIG9mIG92ZXJmbG93IFsx
XS4NCj4gDQo+IFsxXSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL25leHQvcHJvY2Vz
cy9kZXByZWNhdGVkLmh0bWwjb3Blbi1jb2RlZC1hcml0aG1ldGljLWluLWFsbG9jYXRvci1hcmd1
bWVudHMNCj4gDQo+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lzc3Vlcy8x
NjINCj4gU2lnbmVkLW9mZi1ieTogRXRoYW4gQ2FydGVyIEVkd2FyZHMgPGV0aGFuQGV0aGFuY2Vk
d2FyZHMuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL3Njc2kvY3hsZmxhc2gvc3VwZXJwaXBlLmMg
fCA0ICsrLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9jeGxmbGFzaC9zdXBlcnBpcGUu
YyBiL2RyaXZlcnMvc2NzaS9jeGxmbGFzaC9zdXBlcnBpcGUuYw0KPiBpbmRleCBiMzc1NTA5ZDE0
NzAuLmZjMjZlNjJlMGRiZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL2N4bGZsYXNoL3N1
cGVycGlwZS5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9jeGxmbGFzaC9zdXBlcnBpcGUuYw0KPiBA
QCAtNzg1LDggKzc4NSw4IEBAIHN0YXRpYyBzdHJ1Y3QgY3R4X2luZm8gKmNyZWF0ZV9jb250ZXh0
KHN0cnVjdCBjeGxmbGFzaF9jZmcgKmNmZykNCj4gICAJc3RydWN0IHNpc2xfcmh0X2VudHJ5ICpy
aHRlOw0KPiAgIA0KPiAgIAljdHhpID0ga3phbGxvYyhzaXplb2YoKmN0eGkpLCBHRlBfS0VSTkVM
KTsNCj4gLQlsbGkgPSBremFsbG9jKChNQVhfUkhUX1BFUl9DT05URVhUICogc2l6ZW9mKCpsbGkp
KSwgR0ZQX0tFUk5FTCk7DQo+IC0Jd3MgPSBremFsbG9jKChNQVhfUkhUX1BFUl9DT05URVhUICog
c2l6ZW9mKCp3cykpLCBHRlBfS0VSTkVMKTsNCj4gKwlsbGkgPSBrY2FsbG9jKE1BWF9SSFRfUEVS
X0NPTlRFWFQsIHNpemVvZigqbGxpKSwgR0ZQX0tFUk5FTCk7DQo+ICsJd3MgPSBrY2FsbG9jKE1B
WF9SSFRfUEVSX0NPTlRFWFQsIHNpemVvZigqd3MpLCBHRlBfS0VSTkVMKTsNCj4gICAJaWYgKHVu
bGlrZWx5KCFjdHhpIHx8ICFsbGkgfHwgIXdzKSkgew0KPiAgIAkJZGV2X2VycihkZXYsICIlczog
VW5hYmxlIHRvIGFsbG9jYXRlIGNvbnRleHRcbiIsIF9fZnVuY19fKTsNCj4gICAJCWdvdG8gZXJy
Ow0KDQpKRllJLCB0aGF0IGRyaXZlciBpcyBkZXByZWNhdGVkIGFuZCBzY2hlZHVsZWQgZm9yIHJl
bW92YWwgYnkgaXQncyBtYWludGFpbmVyczoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgtc2NzaS8yMDI0MTIxMDA1NDA1NS4xNDQ4MTMtMy1hamRAbGludXguaWJtLmNvbS8NCg==
