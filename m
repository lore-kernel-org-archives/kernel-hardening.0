Return-Path: <SRS0=lmjz=FL=lists.openwall.com=kernel-hardening-return-20538-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1A4C433FE
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Dec 2020 20:04:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6D5AC2368A
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Dec 2020 20:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D5AC2368A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20538-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6002 invoked by uid 550); 7 Dec 2020 20:04:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5967 invoked from network); 7 Dec 2020 20:04:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sa6Sb1BQTbIK2NlQmdxTgQ0S2oifo8J2K70H4M9tzhQ=;
 b=tfOqdjOZDqILO3HHbidQfr9xEXTLbrnWzwz0MuvSaxZGvjQRvSgs0q1UMRkg+grX1HyAUxvzXvyG1bA2wUzXWhQvB7vVQSFCw4q8H+uDhczGQ4Z9lkFILEacoJsBQ6vPhFvQMLTs85sR3IzNHam3NHeKKJ8MTrn1GhEmMh94UEs=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 62f5874024543cbc
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sf+bue57AaLQ0crJvGiZ15AXGuVIR2UQwTMuXa0CYi4QXcCDfhYbwrU6eKI7/jqSyNJuGCyrfCCsLhf+MVDQMFZNUieHVwQ5DMx4HijPe+uRct5R5n/gxX4th/9NFH6+dwaRBa08LXxk9Jd1FA/47rci/z+81QFcN9ZLQWKKJ4Jvetf0v3y7o7DbGqXdbbFTFv2CXOgNbqblcIGrgIMZjSZWm5goJ/l0xXFRf5GRNGR2o1f6ERpirRNHUYyqLTTAFR4MVzVry7t0Ed4bCrfzS6Ms0u5EcavBaoLaPJ/af49dIOW7d9idZASnSFAIB3JbsQy3+i22f1QTWzx6aM1kzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sa6Sb1BQTbIK2NlQmdxTgQ0S2oifo8J2K70H4M9tzhQ=;
 b=kO6uQ3bVCthiEpJ9J8wm4Ev6ShOkc+SWRY2kksYS4VWCOCWMtOGxsOVltf8k4vGq7GCmREC6QHwnsrF0Zlgtm5dUKzONhS4porTbdUe6T9oX+YRetpcgxu5KMN/Qbw09B3J1UPEKz/PrKLgRle62cXuT0XYgmBGO6Yv6pzSWHo7nlJytqX81F3Wl82NQBBI5LfCwnQ1rSfK0XWRRaV63a5BPVMn1bKh5PaHL4tY8EraRlwzjnwZoiymJ6Au3ksgNzXPSRLpJVF8YYP7jcuNWt5n6DT35jNXth3qukvcnt1THQTf+O/+AUEqdL6JkeOB6s3QpeGQZ3VRs8rYE+cY3zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sa6Sb1BQTbIK2NlQmdxTgQ0S2oifo8J2K70H4M9tzhQ=;
 b=tfOqdjOZDqILO3HHbidQfr9xEXTLbrnWzwz0MuvSaxZGvjQRvSgs0q1UMRkg+grX1HyAUxvzXvyG1bA2wUzXWhQvB7vVQSFCw4q8H+uDhczGQ4Z9lkFILEacoJsBQ6vPhFvQMLTs85sR3IzNHam3NHeKKJ8MTrn1GhEmMh94UEs=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Date: Mon, 7 Dec 2020 20:03:38 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: libc-alpha@sourceware.org, Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kernel-hardening@lists.openwall.com,
	Topi Miettinen <toiwoton@gmail.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201207200338.GB24625@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
 <20201203173006.GH2830@gaia>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203173006.GH2830@gaia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LNXP265CA0044.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::32) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5f2673a-503b-4527-7e23-08d89aeb3b21
X-MS-TrafficTypeDiagnostic: PR3PR08MB5658:|AM6PR08MB4150:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<AM6PR08MB41509A1F5B061BAD4A7D3BD1EDCE0@AM6PR08MB4150.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 pIie1k0poU1jSwHWwOVN5Ce6hZA0irwTl9Ktt5U6GRz/3qzDrJdT8LsI0qtgsDyPBmqZ1O+uhPpfhH0QDf1B7x/QN6jRPQSyXgePJPwlf6rdEk2/qERnPIdT6zbfeuetiBjA/YuJVjrthePKQpvFZDckYzOAjDRQbtmO1qqMSei7jUtdkMr5+Fwd5Z09DOOweuFwm57nESTyjMnLsk1nTCgsFxLBAyp1OMjiK7D7iSkB6WECGkdpSdC2dbw7LlQh29Z/kRPzV1MpvZGjygvmXjQg4egWrusdKp8YtUGs1eVWbQ2hdephE73ApL4XxjzyAWNc03tegKl//VSZbeJFT30bsL8yPWorl1J61dM7GuhXbstaXH1trv85WE2Kr5E1YraoVd9h3Gld7mjXg1H+PTtn4ef60+6FRtErLDl3hr+OYw0zGt8dpU44DsYOVnYZozKSs/I+1WWX02QNSi7FKw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(16526019)(55016002)(36756003)(66946007)(52116002)(186003)(33656002)(26005)(4326008)(2906002)(66476007)(1076003)(66556008)(316002)(5660300002)(478600001)(8936002)(6636002)(8886007)(37006003)(956004)(6862004)(44832011)(54906003)(966005)(8676002)(83380400001)(2616005)(7696005)(86362001)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?utf-8?B?MzRqbkRJQVNGdDJQWGNWamNmYnJFcytQaXJUMTJ3UXpCbGR3TnlRb2lzdWpp?=
 =?utf-8?B?SG94U0xKK0ZHTnVTYk9zcWZJMVVtU2tLNUpyZDlhbVRVOGJ2aVdoRzh0V3ZG?=
 =?utf-8?B?LzVMQmVDWW5iT0dLcXlaU1B1TG5HdWlOQmVwdFVpZUl3YWxpZ2FMMXlJVnYr?=
 =?utf-8?B?enQ2eHBqMUhST2NjWFBTK3NFajB3aHo5Z1Y3eEVEdUxoQmRZQlp6UlZBejF4?=
 =?utf-8?B?NnlBeXJGcC84UFdYRWFCWnpSRG1xM0E0dFRLRWJyM0dCZElseDh3T3JNWmQ0?=
 =?utf-8?B?L3NtUUM0TnBYU3dKVndxV0plVFVobFF0R3VDQnBNSUpadGhzajdzTVMyTk1Z?=
 =?utf-8?B?S3hyTmx3Tk9QUGdjWCtrYUpLUS90WDVXNWtVbTU0WXFrOU9JZjRFbTZoS3JX?=
 =?utf-8?B?SXVoMzFCd09YWmJGbG93enBQY2haOWxmaGhiTkR5bUtsS3MrRXBaUWZHcW94?=
 =?utf-8?B?Nm1ZSnJINVA3RlJRcnRvNXNtblRDbUNMM3NrM2Q3SFhSaWhyTWUyYXRBMStU?=
 =?utf-8?B?Mk53TFZ6eFVpdUZjYnhZZzhYNlJUNVB2aU5LN3VyRmZLZWkydFI5M3lDbnRR?=
 =?utf-8?B?a210ank0RUhWc0lmcnp2RzNlYmxlNHJyRERoSmI1NHZmbTRMMkt3RElTTG15?=
 =?utf-8?B?Z3RNUUE4anQvc0NxdW1pdTZrdGRWaGwzTElMMFU5WG1kZ05RdXluUHFZRG9s?=
 =?utf-8?B?d3lKRmxwMmlubklRRjNQVnlISHJrbGlYRVdhOVJSREZzV2pHQjd6L05TZ0dw?=
 =?utf-8?B?NEx1RW5Bd1VIRTVVSkJCU1BGeTQ4cUNNWjBDZXhaN09tOWNvclJudkZzMjBL?=
 =?utf-8?B?aWxJNk0zL2E0TkZhTTNOeTFFZmxOQjFUTmdCRThHeHVxb3cvUFRpblJyN01t?=
 =?utf-8?B?M0NVSzB0V0JzODRBYk1QUTdyd0tqVkhLakRGdXJlbmJJT1JHdlpBSUFZL2ow?=
 =?utf-8?B?dy9XaUxjdHkzcktTdngwUHZmbmNqQXBMd21HN2tYSTY5N0l2MGU5ZHNmTkgx?=
 =?utf-8?B?bm9VK3BFTWdhc05XMno3WWIxaFI4WTdmdjNaZmlHYmJqN2l1V1NZejFKcGxh?=
 =?utf-8?B?SG9BTWJUV0xPVnhXcW9TS2I0YXlOc0YvTm1zSWFSanNxd3lxcWtXWW5JbWMx?=
 =?utf-8?B?OFg2UDkvNTNyR09ZNFpkbWNxWlZkY2xJNVpDZkxyLzJBM0dMQTV2WWoxQlFW?=
 =?utf-8?B?V1JNU3d3Y2VYNlhDOWlya1QzMzBVTzJ4cHYrL25OT3RHRWNlMEJsRXFLeCtw?=
 =?utf-8?B?cUs2ZTBjWXZmbFJnOFBSdnB4bzlIekk5Vmh5anVTNjFLa0RqcWphR3pDQjV0?=
 =?utf-8?Q?4sLmq/U2437lpnwP55+CVgyCLpy0st9iFW?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5658
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	86ace2e3-5323-4ddb-4047-08d89aeb30d7
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Drq1EutGzvLW63UP3X8c8wv5IcEKm5bY7Jh9NmRt4d33GZnuxySgRLtMu7lD39slKUtGq1dqYmRZp+Dq8z1KwieslxnD1cQi0+0bIpvbDS9JOi4DWapqZH/zefP72L0OkzcoZjawjIWDoGfBGw9QMla6ew34B8ovk2D1aHhp/Oo/4GaFEF/pkCmLJitvbirhHKq73uyb5Da1UhIa3TNtzr9JI1SMhKIUQMIel9DjlL1QDRzFc7PeaXXJYX9Wfg580RAu+ULtM1mIcbu69GU8wTV074d9dHqO/LFTJ1htKp9VO/Q5VR160h0E4xVeBhc6NGKn+J4x5DsXAraZFwaHLtxZ/LlwYOQSrxOe1+CTGpupQR6QqOXc9mPfbv7jm2AlVkQ0xT18qxzWxEc3QpEOb9wSju1dYfcZkKpo1Cpgn4nizMBbIctg5rggogoUZlOsE5jP9xO9it+J/X6C9UeL6PiDCaNieIY4UiU1YddvuT2KOIaL//s5vPwteRbj42Ci
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966005)(8886007)(81166007)(70206006)(36756003)(86362001)(7696005)(4326008)(6862004)(956004)(1076003)(82310400003)(356005)(83380400001)(47076004)(55016002)(2616005)(316002)(966005)(70586007)(2906002)(6636002)(5660300002)(336012)(107886003)(26005)(37006003)(82740400003)(8676002)(44832011)(16526019)(186003)(54906003)(8936002)(478600001)(33656002)(83133001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 20:03:57.2758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f2673a-503b-4527-7e23-08d89aeb3b21
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4150

The 12/03/2020 17:30, Catalin Marinas wrote:
> On Fri, Nov 27, 2020 at 01:19:16PM +0000, Szabolcs Nagy wrote:
> > This is v2 of
> > https://sourceware.org/pipermail/libc-alpha/2020-November/119305.html
> > 
> > To enable BTI support, re-mmap executable segments instead of
> > mprotecting them in case mprotect is seccomp filtered.
> > 
> > I would like linux to change to map the main exe with PROT_BTI when
> > that is marked as BTI compatible. From the linux side i heard the
> > following concerns about this:
> > - it's an ABI change so requires some ABI bump. (this is fine with
> >   me, i think glibc does not care about backward compat as nothing
> >   can reasonably rely on the current behaviour, but if we have a
> >   new bit in auxv or similar then we can save one mprotect call.)
> 
> I'm not concerned about the ABI change but there are workarounds like a
> new auxv bit.
> 
> > - in case we discover compatibility issues with user binaries it's
> >   better if userspace can easily disable BTI (e.g. removing the
> >   mprotect based on some env var, but if kernel adds PROT_BTI and
> >   mprotect is filtered then we have no reliable way to remove that
> >   from executables. this problem already exists for static linked
> >   exes, although admittedly those are less of a compat concern.)
> 
> This is our main concern. For static binaries, the linker could detect,
> in theory, potential issues when linking and not set the corresponding
> ELF information.
> 
> At runtime, a dynamic linker could detect issues and avoid enabling BTI.
> In both cases, it's a (static or dynamic) linker decision that belongs
> in user-space.

note that the marking is tied to an elf module: if the static
linker can be trusted to produce correct marking then both the
static and dynamic linking cases work, otherwise neither works.
(the dynamic linker cannot detect bti issues, just apply user
supplied policy.)

1) if we consider bti part of the semantics of a marked module
then it should be always on if the system supports it and
ideally the loader of the module should deal with PROT_BTI.
(and if the marking is wrong then the binary is wrong.)

2) if we consider the marking to be a compatibility indicator
and let userspace policy to decide what to do with it then the
static exe and vdso cases should be handled by that policy too.
(this makes sense if we expect that there are reasons to turn
bti off for a process independently of markings. this requires
the static linking startup code to do the policy decision and
self-apply PROT_BTI early.)

the current code does not fit either case well, but i was
planning to do (1). and ideally PROT_BTI would be added
reliably, but a best effort only PROT_BTI works too, however
it limits our ability to report real mprotect failures.

> > - ideally PROT_BTI would be added via a new syscall that does not
> >   interfere with PROT_EXEC filtering. (this does not conflict with
> >   the current patches: even with a new syscall we need a fallback.)
> 
> This can be discussed as a long term solution.
> 
> > - solve it in systemd (e.g. turn off the filter, use better filter):
> >   i would prefer not to have aarch64 (or BTI) specific policy in
> >   user code. and there was no satisfying way to do this portably.
> 
> I agree. I think the best for now (as a back-portable glibc fix) is to
> ignore the mprotect(PROT_EXEC|PROT_BTI) error that the dynamic loader
> gets. BTI will be disabled if MDWX is enabled.

ok.

we got back to the original proposal: silently ignore mprotect
failures. i'm still considering the mmap solution for libraries
only: at least then libraries are handled reliably on current
setups, but i will have to think about whether attack targets
are mainly in libraries like libc or in executables.

> 
> In the meantime, we should start (continue) looking at a solution that
> works for both systemd and the kernel and be generic enough for other
> architectures. The stateless nature of the current SECCOMP approach is
> not suitable for this W^X policy. Kees had some suggestions here but the
> thread seems to have died:
> 
> https://lore.kernel.org/kernel-hardening/202010221256.A4F95FD11@keescook/

it sounded like better W^X enforcement won't happen any time soon.
