Return-Path: <SRS0=fRHJ=EK=lists.openwall.com=kernel-hardening-return-20347-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B025C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 08:57:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B65BF216C4
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 08:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="w6MgidbL";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="w6MgidbL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B65BF216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20347-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19800 invoked by uid 550); 4 Nov 2020 08:57:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19777 invoked from network); 4 Nov 2020 08:57:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbg7ZlkQGrs9mWpDpDnhBnGQgwzsQZ68Hh/dPW1plb4=;
 b=w6MgidbLJ+bSeTglCo1E+12pzjSHsXwxAmvcgzFBGF/571oVdYB7yJ1C5RjXRhPqyeN9W+PKC0b26qklSoLUVb96eIml8ZARWujHJm9nYGXHYc/XGz8e3tV/Aj0D8GDw1Bxg9t9NF4Gl8re4/m6ZIihSm4kT6PODIWOZze/EN28=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: abf9ad6c60bd9186
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRzt1Ww7p9tvIHcuY2dmCrbkNjh5ySNjvJ2GO7W70VtWyFYqYltgfCIxvbbW9RVgnQoh08FjVYmX6gKA/ZTWdwL72jTH3nu1aJmoP46+YDAHNSUtVffxDb2Dj6dpmY6C/U18gijs/7rNWD7Jk8U94cgSt53hbQSVPTU2Q6mUEZ+DR8IZz4Sa7M/BZZNxqdH/ny4Mwfny+4MHtGoVI6lgvka5MSaxlsApCMmZY80BuxnTtoELVqOhebTrEJwblMuzjOWwZ5Hu8cD93U8YTN327YHdNdZgXtAUhEb7JOFT2lBGqUagdAkcIThB8fYbaj3fpsV4KYYSxKdWBSlBWt4asA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbg7ZlkQGrs9mWpDpDnhBnGQgwzsQZ68Hh/dPW1plb4=;
 b=FREze/9ehdrHDs7X2VGvVa9vJ+bUF5Bb5CNVav29UVyaaNdghYJxUvmaGMDYrAFsDgUFrggBM1hOF5UubVlTU7Ed55r4Yo2LX6GS0h9Bt3BYaHaCrDQS8GTuaeBOhqajyIEfWQQtVvBU0vgwd6RKruyo+FiNGYOthYr6LxhRPvvEgGk0bDcGkCZu5zsszam8nJ+b2gAWNmiIH2auUY+iJYg0TJ0ngKUXWOBi1do5JPQGzGL4ejwt647F4iT9o4us3OgOHMIDxJGKd5XR18nl42rjlrbQoU4Ays9dlroIPgQkJqqwP9X9sqrJ1iprLpepjl1E+vjOYCEO/BNpp7dfWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbg7ZlkQGrs9mWpDpDnhBnGQgwzsQZ68Hh/dPW1plb4=;
 b=w6MgidbLJ+bSeTglCo1E+12pzjSHsXwxAmvcgzFBGF/571oVdYB7yJ1C5RjXRhPqyeN9W+PKC0b26qklSoLUVb96eIml8ZARWujHJm9nYGXHYc/XGz8e3tV/Aj0D8GDw1Bxg9t9NF4Gl8re4/m6ZIihSm4kT6PODIWOZze/EN28=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Date: Wed, 4 Nov 2020 08:57:05 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Jeremy Linton <jeremy.linton@arm.com>
Cc: Mark Brown <broonie@kernel.org>, libc-alpha@sourceware.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	Florian Weimer <fweimer@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Topi Miettinen <toiwoton@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201104085704.GB24704@arm.com>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <8c99cc8e-41af-d066-b786-53ac13c2af8a@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c99cc8e-41af-d066-b786-53ac13c2af8a@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LO2P265CA0248.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::20) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ab50e3e-e1a5-4f8e-1349-08d8809fa107
X-MS-TrafficTypeDiagnostic: PR3PR08MB5564:|DB8PR08MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DB8PR08MB4153A28728751B8BD1C8DFB3EDEF0@DB8PR08MB4153.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 lJkiyGppbMyn6xQP8zi6Yi6ibBpMVjELjR432SfnFytFUSXEvhxRRX4GMsgmDZZNCb+ZeQx+KwWSiMNu7NS2fb7WNdi9Gt2pqTEl1tnsHqMM98gR0n8rUoBOc8sRD/arBhrw+Q871raUpr6bfGnE5Ba416H/4RM/JjoEthXX7GsB8HndGTf6bow+f6rLWP9hgNpp5RmRxmx3tZ3XSX+891uyxAQjdXA5GHzR7veok0ztRFdHLKx8fRGAXFWs9gy5EQqE0Cov9Ajr5nlRVG1006aCgANzq1nxikXm0wmoZXvMsHktqjMj+dOv7beoTiEHXv5ANT4+DrA4618jrEZSfZGZAaInhf5FomK81Ue+enKB2H/qBUDTorCQBe/XX1cO
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(86362001)(186003)(66476007)(66556008)(44832011)(66946007)(5660300002)(4326008)(7696005)(55016002)(16526019)(8676002)(52116002)(83380400001)(36756003)(2906002)(8886007)(1076003)(2616005)(6636002)(6862004)(33656002)(54906003)(7416002)(37006003)(316002)(53546011)(8936002)(956004)(26005)(478600001)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 D46UPxVWWHNfMsRySJMroSbD6x51AOjRT5W2DJTfz0NsOGoBptx4oD5vF9MvkiajZOMI0DNwMnBnpeh+4IyIJDKg3BEk2y6CfIUJwe693NCf9reWxbinx0hnCfzvqK4e+wipchXjbzo1+Zsj8390YvnQ/UiGEMbl15YakcA8aqJuOROvHHbMU5/r46gbAdLmB/oiVNIuQIjkwzVJB/UEMC5ijtytH1giekCkPhbTKHebS6DjDzVGvH9C1RPmt5JM0aDBYpTxyRXlDPsscAnT7wBjYtBf8AndLB2U61pABswfI0109Bt0TAurpBHO2cdjf+jjc6CWOBnH8AUAV10OfwtlkFqEXU5roWcHBLHq0zowPEDqm8Nj7J6KeS7Kv8MDre9w+ssU6u9lbAddXFqTmi+L1g9boIZC0H9g2hIzs8E+AzPpYznGFYjyvR6mkfnbVmFhiS6x4+hWDOTIQJgw2bbM14nchakpu/X/THAkQ8yVKQ5+IsXvOzc/IlpMzVMBUgqzq/jE7aC3hoDb5QH+6uzA7nlJB0OWNUSxr4KYMBodbJASLPYuPE29WFFDPgij6/X9fUwpjE9RdbygkmBqd5roXzOeRumdKCz+B15Xz3pzMx6sMia7mqr4gE8YyOB7zr87DfSZ+NSCGl9bheIelw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5564
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT045.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	062ded2c-a6d6-497b-3f52-08d8809f9bba
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GlZDUJgFsAxrs5Jgc30dqFxtUi4Lkwh34dTSIUQ3wnTKTAz89Onx8BCmQQOeLqE3igsvaq2e1p5njXywmU3mpYzy3oCqnGwGsz+lgIejWAaOK6jXWFguT1hmj6/WjcuOTp6xFTUifQ53s/UN8OcpHSBTSd1nyxWtPTtQ01i4SE1nD+jxJYClqzv/YE5lpvId0655ImGJ6BAuj7AmC/EQdSh7Ku85oqgEiNAdSRf2KyBDegowdWW7lEWnezQaHBsREIXJP575r2/j4Wi4Tw63leXjPgWKoXdyh7TjnSc3qDj0mgbyuCNML7puPjEWxzXS3uXSxojrPSS4HNEmF9TcylKe6c8IK/T+dvMILYCQOY+sgkFUNig9xymRFYqdakBLUwQV2pjpAOOkt03njz4+7GJJ/tEsEMH1yl8PEaTfLfw=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(46966005)(16526019)(70206006)(336012)(1076003)(5660300002)(2906002)(70586007)(8886007)(478600001)(53546011)(54906003)(956004)(8676002)(8936002)(44832011)(186003)(47076004)(55016002)(26005)(356005)(82740400003)(316002)(36756003)(2616005)(107886003)(86362001)(83380400001)(82310400003)(6636002)(37006003)(6862004)(4326008)(7696005)(33656002)(81166007)(83133001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 08:57:16.2586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab50e3e-e1a5-4f8e-1349-08d8809fa107
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT045.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4153

The 11/03/2020 23:41, Jeremy Linton wrote:
> On 11/3/20 11:34 AM, Mark Brown wrote:
> > On Tue, Nov 03, 2020 at 10:25:37AM +0000, Szabolcs Nagy wrote:
> > 
> > > Re-mmap executable segments instead of mprotecting them in
> > > case mprotect is seccomp filtered.
> > 
> > > For the kernel mapped main executable we don't have the fd
> > > for re-mmap so linux needs to be updated to add BTI. (In the
> > > presence of seccomp filters for mprotect(PROT_EXEC) the libc
> > > cannot change BTI protection at runtime based on user space
> > > policy so it is better if the kernel maps BTI compatible
> > > binaries with PROT_BTI by default.)
> > 
> > Given that there were still some ongoing discussions on a more robust
> > kernel interface here and there seem to be a few concerns with this
> > series should we perhaps just take a step back and disable this seccomp
> > filter in systemd on arm64, at least for the time being?  That seems
> > safer than rolling out things that set ABI quickly, a big part of the
> 
> So, that's a bigger hammer than I think is needed and punishes !BTI
> machines. I'm going to suggest that if we need to carry a temp patch its
> more like the glibc patch I mentioned in the Fedora defect. That patch
> simply logs a message, on the mprotect failures rather than aborting. Its
> fairly non-intrusive.
> 
> That leaves seccomp functional, and BTI generally functional except when
> seccomp is restricting it. I've also been asked that if a patch like that is
> needed, its (temporary?) merged to the glibc trunk, rather than just being
> carried by the distro's.

note that changing mprotect into mmap in glibc works
even if the kernel or systemd decides to do things
differently: currently the only wart is that on the
main exe we have to use mprotect and silently ignore
the failures. (but e.g. some return to libc attacks
are reliably prevented since libc.so guaranteed to
have PROT_BTI this way.)

the patchset is a bit more intrusive than i hoped
for, so if we expect to get a new syscall then
simply ignoring mprotect failures may be a better
temporary solution. (and i still need to do
benchmarks to see if the cost of re-mmap is not
much more than the cost of mprotect.)

changing the seccomp filter in systemd does not
help if there are other seccomp filters elsewhere
doing the same. i think we will have to avoid using
mprotect(PROT_EXEC) or at least ignore the failure.

> > reason we went with having the dynamic linker enable PROT_BTI in the
> > first place was to give us more flexibility to handle any unforseen
> > consequences of enabling BTI that we run into.  We are going to have
> > similar issues with other features like MTE so we need to make sure that
> > whatever we're doing works with them too.
> > 
> > Also updated to Will's current e-mail address - Will, do you have
> > thoughts on what we should do here?
> > 
