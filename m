Return-Path: <SRS0=GCRb=EL=lists.openwall.com=kernel-hardening-return-20365-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D28DC388F7
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Nov 2020 11:32:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E0E642078E
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Nov 2020 11:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="62WlQt/g";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="62WlQt/g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0E642078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20365-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20140 invoked by uid 550); 5 Nov 2020 11:32:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20117 invoked from network); 5 Nov 2020 11:32:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVIIhf6JmC5niIMJMRh747lTJvTdhx8XlS5YiT+IuLw=;
 b=62WlQt/gl5l2Gv5Oicj9UrDc2juvD4oKamTqVKKnF2WiEbVC5gxY5AgPpVZP6+/AoxKz+5szoZD4Bxsl6N+okFjKxSHxHkESICWUie40i50jNOYkVM+CxHIMWVCZVGPeLc/zsHuDBmoiKWnpHatPmJmCZDPBoB5A5rDB42K94hE=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: d910f8f3d14945d4
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G18mkZAXkt/XwOq0+b9TGBP1N5hskGIXRFaS6LFuct75ppnPx8uWwBu4le3VTCiYDNdD2pRNdqXCUqooZH0U5iGBgKL+tJjrxr30YeLIEaBVlVlZJSKFOZf77ktHVwjpv0jCVEoYbFru21WrlupA2EKVX6rEfoVSZwianqCwqsIpxGVjxXexRsMduRQIWfD52iQQmQbIBZkWrXCOkWazzpsJDe1NjyGiTvXrqEUE4moocVp5+1apkXXCXSCg9cxe+UJfFPOskeei/urjcaUfI6l88x0vdin1VmriXzkWtJt/hqTleEmMcwEBFrq0vxbf9+1gYrmsIzkNwYcjxSCgFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVIIhf6JmC5niIMJMRh747lTJvTdhx8XlS5YiT+IuLw=;
 b=OHaXHy3BYcA8VqoSTvEQ0FP8f6UBkqSiSFTK7WfRAq/kFIDml6gFHevGAdWDQ5vysbyaHwvtACmW/sOdwHXZByx/mAIE62TAmocRS2Nvy98r0bCYeJoZzEZ9sFfw2mfserrPzsV6eVdrWR3FiWBoAJ8y5iwRAeh06QlyUSdCA8yDCDlTepQEN7VkzFggnHeIQSuLBcY+r+0ip9n+VIsbnBL8TAqcuUedIZw0FVOjxIBEpVsAlkbL9i+MHm6ExvEjM0kSXDYWGjM2gj04i/K4wAisPkR7TY3YBK1KGZRb7Oes+co+6bSmFWoaBddDkUsmBMpL+isgsCLQ3e6FmCgvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVIIhf6JmC5niIMJMRh747lTJvTdhx8XlS5YiT+IuLw=;
 b=62WlQt/gl5l2Gv5Oicj9UrDc2juvD4oKamTqVKKnF2WiEbVC5gxY5AgPpVZP6+/AoxKz+5szoZD4Bxsl6N+okFjKxSHxHkESICWUie40i50jNOYkVM+CxHIMWVCZVGPeLc/zsHuDBmoiKWnpHatPmJmCZDPBoB5A5rDB42K94hE=
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
Date: Thu, 5 Nov 2020 11:31:51 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, libc-alpha@sourceware.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20201105113150.GE24704@arm.com>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <20201104092012.GA6439@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201104092012.GA6439@willie-the-truck>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: DM5PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:3:c0::27) To VE1PR08MB5566.eurprd08.prod.outlook.com
 (2603:10a6:800:1a9::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 37ef157d-9f19-47e0-3ee7-08d8817e73e4
X-MS-TrafficTypeDiagnostic: VI1PR08MB3056:|DB6PR0802MB2455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DB6PR0802MB2455A177ED8230E9C1140F8DEDEE0@DB6PR0802MB2455.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 pxzTHn2kbh+qlbsS0m5ePVO/jQvxlvZFEJOxdMRuG4lV4IKWMBAo7wRO3km3jTOz7fn+zxaQZZ5g0Tw0cXd4AvogtnzP/PAFe6ylQKlLydywnVmSapw1bammfQ10vKf82pNT2ZQ3KHNipcotD8yR5wRPhjoAf4eNFvdxqmSwI23XJAxG+thn9aRZU6NOwSYlndwu+0ThKE1dOykPyoYk/gY1WbwwO7tUhmuLis5OdI4PbyhdQB8+INl0UrloQolDB5wjJiArN2p3pz2MT49wmY0iLN7nMp9RQHxi9guxZ3Xf5yiBrFqFSh2sn2pB/FdswIc+boEKz1rwgvkxbunOWoQQrky2g7VXRX9tzUJtLcoC1Au8qu5IEXHgtujDh/t4
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB5566.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(86362001)(83380400001)(1076003)(26005)(316002)(5660300002)(478600001)(33656002)(8936002)(44832011)(54906003)(4326008)(6916009)(7416002)(8886007)(55016002)(66556008)(66476007)(66946007)(7696005)(52116002)(8676002)(956004)(2906002)(2616005)(36756003)(6666004)(186003)(16526019)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 1RrrocvhDNsYqP2IDn+ljauMdZ5n1/KwXyA5qZKnk/jGjXDclR5mp+VEIwZdXEjSDqHxXB8RstLVl5vqv5g4N/yRyspRi5EPRXKMu/kGpCZX9Ti/0rB+B7kAoQFilOX/AAOuApgYv03sKWv32j+OslkOSBkmqipEzM5HYBq8zXAlMVSbxf7HeKlKt/84jqeNupHE9OPDVn0cmsNL4nWua0id230BQCL27wBTgder7+4YVD0eQU7vvOThmcWQsTAl12V0ns7Py9+TSKP1qRybgs4zju++yDM6MaLPXj6AfnirrJM2diUTJOWwZHYBcXTsBk4PJSed8HIdnvCcp9bJRI+fi7oPizCVUDzj7+wU1XcXqQ+S3sJcV2tKu0sN7T2dQ/T7HvCJ4Lh8dDiCh1ykcy5Zxsf6EDCVvLk2E/sTBDLLMFqe/1E+YTxOQFOxa5OYAOYpigSaMsL+0x2P9IWBKLeEsehFoJr6hXQL2xL3Dm0OctdVPu/Jq92A02evnAwZh2tOu279kQsljby7Dzeie9p43yGefYmMK1Vn6g4KpgzCpUwCMF5sLLjfxYOqu+R81YlwRuEthhsYIX3qnvIVqbl9V+ce5tvTytuKc16dLFEunH72i2OZ7K/pYJ8nXcmwYfmALT70Y+SjSEcbmdeI5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3056
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f01b762b-43f7-4358-158f-08d8817e6a22
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9qXQlN2yulhgA2KbMdHe3np73/4UjlXdaqdeayuZ1FLPSoFf1pxmTSp9VS7WVSAn1ro+mu1brqH+nhAhfkr95H8LpAvIZVyFGkUo6EGK/7SkmEC3G9GQnCCqUj1DFmQvjhEwKEMQRQroUk2HVts3HsbgH7pwE8bukekFYRG6rkn68rk8TQqOScv4Is3Oje0vSNU/1AJplFBWLNWDtwJvoBAJRImPorOuSxcN8zYpHNnVSiDnRS4Ju+vflLwyGK8fIkRkPOtR68R2/bu/99RSRgL2I196xZcQKsycjgZGSITln7/clVVkjrEddB3iQPzt8HWv6mgv6k6fudkheWu8Zqop9tb0GLDmv21VM6JFdH0bl6Loov4tAaqbW2BudlNBuIRveexTKJxqUyyk5VQqLc9A0eTS2sFIpsO2I0DEVsg=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966005)(4326008)(8936002)(81166007)(36756003)(478600001)(33656002)(356005)(47076004)(86362001)(83380400001)(82740400003)(82310400003)(316002)(7696005)(2616005)(6862004)(956004)(70206006)(2906002)(186003)(55016002)(44832011)(6666004)(336012)(54906003)(8676002)(8886007)(16526019)(26005)(5660300002)(1076003)(70586007)(107886003)(83133001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 11:32:18.3015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ef157d-9f19-47e0-3ee7-08d8817e73e4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2455

The 11/04/2020 09:20, Will Deacon wrote:
> On Tue, Nov 03, 2020 at 05:34:38PM +0000, Mark Brown wrote:
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
> > reason we went with having the dynamic linker enable PROT_BTI in the
> > first place was to give us more flexibility to handle any unforseen
> > consequences of enabling BTI that we run into.  We are going to have
> > similar issues with other features like MTE so we need to make sure that
> > whatever we're doing works with them too.
> > 
> > Also updated to Will's current e-mail address - Will, do you have
> > thoughts on what we should do here?
> 
> Changing the kernel to map the main executable with PROT_BTI by default is a
> user-visible change in behaviour and not without risk, so if we're going to
> do that then it needs to be opt-in because the current behaviour has been
> there since 5.8. I suppose we could shoe-horn in a cmdline option for 5.10
> (which will be the first LTS with BTI) but it would be better to put up with
> the current ABI if possible.

it's not clear to me how adding PROT_BTI in
the kernel would be observable in practice.

adding PROT_BTI to marked elf modules should
only have effect in cases when the process does
invalid operations and then there is no compat
requirement. if this is not the case then adding
PROT_BTI on static exe is already problematic.

if there is some issue with bti that makes
users want to turn it off, then they should do
it system wide or may be we can have a no-bti
option in userspace which uses mprotect to turn
it off (but since that has to be an explicit
opt-out i don't mind if the user also has to
disable the seccomp sandbox).

> Is there real value in this seccomp filter if it only looks at mprotect(),
> or was it just implemented because it's easy to do and sounds like a good
> idea?

i'm fine with just using mprotect and telling
users to remove the seccomp filter. but that
makes bti less attractive for deployment.

