Return-Path: <SRS0=y5cA=FE=lists.openwall.com=kernel-hardening-return-20471-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9252C63777
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Nov 2020 15:57:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 602D8205F4
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Nov 2020 15:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="fDni5yy6";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="fDni5yy6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 602D8205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20471-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32744 invoked by uid 550); 30 Nov 2020 15:57:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32705 invoked from network); 30 Nov 2020 15:57:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AO1AfwOH/ROY3iZYfMnYkp0a82SNwE5AqLGz0iZHDM=;
 b=fDni5yy6HtW0oX8iO+qiMhGHidPVJJS1zlHH1RcxZIF/DZIzuVdkE73f8UeKq1O43+lLOfA22J0C2+fwAxy3Aox/lWR9zMW0P/YZ9blcW2KpmZi4W+6BY3klDbcazS1NMxbPjTa5CGgEq/IsTcFJzTd10xS6GAmBr1ZgY18qmB8=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: f9b9b9ab4eae0b3d
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n19gdnsFADDsqAnKUSi2elhks6B8ZrkMEUTcHC/YLfRYGmU+UnXAWajUR+1Nqx/HTq7Reeaa6ko2v7zT1bekCIkMC9lw35JUiRXBRP3U+TKI8kOF/t47EYdXffUOmpwc8WhIdOzP8+1pdp4QTEHdDrXIrOSaUx6mfrQeulGTePR/pLACbnfESvwiJwvTQPcdIGqm6MeWXZ4NtwPgSRWpHnsiDh3l5fZidAz3HZghK2vjsop/c8mPbUi6MDGH+F5YHHqDf/gwfhsNFFOtbf8NC/f7fzVahx0naaZXJXvv2Zm4uasaS2dttwPVDlP6wSxkELoO/0jhkJKBFUN/j7At7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AO1AfwOH/ROY3iZYfMnYkp0a82SNwE5AqLGz0iZHDM=;
 b=lXiTJHV583DAEPVypk9AHp6XtQINxil1tKSPWzACuY9+QwHgLj45Tr0eKv+nedOLsv4AgcgaYrNR+pS/NXxnsXsfpsV0rhnJpdkA5OtPl8yDMTN/YHS9+91sGvs39KCxhIlG6S252BCMRDssIRvB6IUjO9oZq7nm5J/VYRQ4lSwa/vBdXteVfJk6nBcY8MG+uC47D07zjV7dg5dsqa1lT1qo8vQbgBYGZCD27TeOd7scATrEHUyfQQfisEeJRUKJkamCz/Jmw4XjCF1YC+izRSAxJBPFW3akzkL0x3nyhfP0uuuuG3NmTFU9wW1dfxHQQvSQ5UkJ3iLyxO/+LPuCDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AO1AfwOH/ROY3iZYfMnYkp0a82SNwE5AqLGz0iZHDM=;
 b=fDni5yy6HtW0oX8iO+qiMhGHidPVJJS1zlHH1RcxZIF/DZIzuVdkE73f8UeKq1O43+lLOfA22J0C2+fwAxy3Aox/lWR9zMW0P/YZ9blcW2KpmZi4W+6BY3klDbcazS1NMxbPjTa5CGgEq/IsTcFJzTd10xS6GAmBr1ZgY18qmB8=
Authentication-Results-Original: sourceware.org; dkim=none (message not
 signed) header.d=none;sourceware.org; dmarc=none action=none
 header.from=arm.com;
Date: Mon, 30 Nov 2020 15:56:56 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: libc-alpha@sourceware.org, Mark Rutland <mark.rutland@arm.com>,
	kernel-hardening@lists.openwall.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Topi Miettinen <toiwoton@gmail.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201130155655.GA16045@arm.com>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1606319495.git.szabolcs.nagy@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LNXP123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::25) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da806007-d17d-4f43-36b8-08d895489d0d
X-MS-TrafficTypeDiagnostic: PR2PR08MB4730:|DBBPR08MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DBBPR08MB592997DEC2D0A8B82D8BFCA3EDF50@DBBPR08MB5929.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 eNjdAxos8CSjmex+5RvaopMlIve+UcKaXnHwYbHzhcLK1Nnl5Vl6ljxCv4+eojs2wB+9EWV89pahbfE4NU/1GAggrDUrhINeWQmpkSa4U5YXWptS9M/kh7Zgr6KAmBak30z6e9Sn1PlsaoX0F8jSY8hYy7Z3x4XkNjRDghJDyRvluJq3Pr/jw6QsBLFv4vG2euxVv8tKYGzsepsiwWf/bX0kyt3NZhIQ/7xXjzi0Eh73+baHHUUWOkB86KAwaAfI6lfmm6T5tFKfUuLanFK0BQVhcaIyJJGzlU+0+72w3atCP+TI6OX3cyXHAe1TwK7OqF7/V6l//SiBvEZN5G3BZjyYhbph+KOGYY9SFoaZgUN51taJYKB5vOhECnarOuqMljbMt/wEzJaftcQU8dh4lWqccTBN22DBOK+k0/XdNuAHSBoCdjrbM+YABiwq54jJf2rpgdASKfR/9bvl/EAb3g==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(110136005)(8886007)(36756003)(2906002)(8936002)(921005)(26005)(478600001)(83380400001)(52116002)(7696005)(5660300002)(16526019)(186003)(1076003)(66946007)(86362001)(66556008)(66476007)(55016002)(33656002)(316002)(44832011)(8676002)(956004)(966005)(2616005)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 =?utf-8?B?YWdYK240Snc2bGV4bENCUUttd3JMcktnR3lNWnZURFROZGxiVEMxMzJNNnVF?=
 =?utf-8?B?WkZ1QXJralhCbm92cWczUUpFczdJTUpxazA5SEtZY0g2a0NBTlhPZkk4Ylpy?=
 =?utf-8?B?QkVZQXhaSGlpcnFCQlkzT0t0ODg3eVRzVmtzWG5IQ0Z1Ykd0WUtzTlJnaTI1?=
 =?utf-8?B?Sjlia1BVcWJ5dTJPMXBqdUFtdFlhSWMwREIwU1BlZ05JY3FBZ09GV3FiaHFX?=
 =?utf-8?B?d01SNU1oZ2FwTGQzL3ROakFiWTg4NitETDlYTXVBT3V0eTRhYThzaEdqYmg0?=
 =?utf-8?B?V1FUcXF1QmdaK0h6VGlpQmhITW5KODg3UWZoQ2lOSU5HZEUzK3k2Z1gzRXhX?=
 =?utf-8?B?Q1Y5OVRITHMrb3BzYWRLVGVrZnl5ckdCclFxcFQ2TW5mSFB2WDVKWVZvVHlH?=
 =?utf-8?B?NjMxUlBBd1hkOGZDeGpBaHZzRjZtaXJzandjcnZIQWRxbERncG84a05jTmQw?=
 =?utf-8?B?RFdZMEJzMGxxZjZWY1NtM2t0QXd0M0ZCMEE5b3R3cE0rR3E0akpCdFkvOG9k?=
 =?utf-8?B?YUpIRjd1YWJvODhjQ0dZa2ZJbitRMzRsRzVEOTFoc3QvUDVNTmZ2R1VWQjB6?=
 =?utf-8?B?cEtVdnZVN3I1VXFsa2x0aTMwNUVsUlUrRVpZNjVRWWhVNTVVNWlQa3NxdFNs?=
 =?utf-8?B?QzEyMW9FajlUMDhKV1gzSHlNb2pualdweEJ6b1ZvQW8wY3hONmZYZ3hpcy9y?=
 =?utf-8?B?T01VRnBvTCswaDB6VHhuS1B0d3NySUxaajl3a0d2SXhLWHBHaWI0cklBWThO?=
 =?utf-8?B?S25RV2RxVktDNHVSY2ZKZ256akh0RE5XRjUwTmNnejZzNDdzZ2s5MVNkcVA1?=
 =?utf-8?B?K0tlMnBvdlRsUHRJelRXcy8rTU04NlIvWTJLTjNObGhVMndwSEdRRDVDVEw4?=
 =?utf-8?B?RjBvdytVUVcwenJlQVJyVWEwTXhmTkFYdThpbStiMENYcG01TENsSDNkMGpx?=
 =?utf-8?B?V2w3c2RmNFhXSGt3eGwwU28yVXNxSkFiMmlUZDJNY1RlM3ZGcllBeGZnek9F?=
 =?utf-8?B?b3ZXSFJncE0rTjJGckNjUkZpR2psL1JvcjFoMjRQWFg3VWpiaVZyTllBQ0FY?=
 =?utf-8?B?NWJpVWtMSFlIQVcwSjZoVE45QUxrYy9RcjducFJNeFRiSE1kc3ZNMDBmSWNE?=
 =?utf-8?B?NU1NN3huS2J5V09qTU9LbXMrTFRjb2hucElYUCtKeVc4NklWZVJrZHRXK3Va?=
 =?utf-8?B?c1lVM1VJcU9UTHhDVHU4K1g5eXdURTdmdkt5QlBMOGxEOXkyQ2cwQ29wRUJX?=
 =?utf-8?B?SEVyV3dRRzk0YThscGF1bG00SVVhQ096cUdzS3E4azU4R0djelhXTTJsSjRo?=
 =?utf-8?Q?1D2ORoxnEvnaQZqJjXKgAdhUw4Tma6Z2mY?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4730
Original-Authentication-Results: sourceware.org; dkim=none (message not signed)
 header.d=none;sourceware.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1bf431ee-c3e6-401a-98b2-08d895489127
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YbLLNmnMj59rTUR0Oz2WBV5Z7sFuUMoF2BSd7aDHBC2/nK43Wh95w+1P4lCWhFd2kIXKTCKhvmQe5tFAhb+9S7Ci8ET3WyYxQcM6Hf2CczTBUGLssX8ona9Vo3x9u5/FaoPyozUWn6+AmPzlSooozs3A1GLpPA4g2gny1NR+rIStEhP642vfzphLMFuoJ638pasJwdZBoWG2ZMKw03yKhDUk4uCeXoTW4AinLH0gzCvPVyB7CnhD+sfh2aiKWtjnbXTFE4ou8aVRKlkCjCxwErr04Ezi+8AGFc4SAk6PdtE2v4z40o3NmBT1qKT6bty6JzQCKIZef7PCBxjOpb3RMVk9Sy72YlDi+OFkIbIH4jQDl/yP0LbSA7oqmzE9b9cb5pEyZ6EVcDLunCIZ5cK5GyhkApiL+ZxkqNaXFurLZVIUNCaQgYCzmAvA1IqUOls1Td111yIYmKXRL/rTO2VXnGn5RaoGXb28fIy4Cm8c4cxFfZUIvBYNc/Y3Ok7nfh2T8C+fP6nWcaht/jeo8BmipA==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966005)(7696005)(44832011)(336012)(26005)(956004)(186003)(921005)(33656002)(2616005)(1076003)(55016002)(2906002)(16526019)(966005)(110136005)(478600001)(316002)(8676002)(8936002)(8886007)(86362001)(82310400003)(70586007)(70206006)(82740400003)(356005)(83380400001)(47076004)(81166007)(5660300002)(36756003)(83133001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 15:57:17.7898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da806007-d17d-4f43-36b8-08d895489d0d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5929

The 11/27/2020 13:19, Szabolcs Nagy via Libc-alpha wrote:
> This is v2 of
> https://sourceware.org/pipermail/libc-alpha/2020-November/119305.html
> 
> To enable BTI support, re-mmap executable segments instead of
> mprotecting them in case mprotect is seccomp filtered.
> 
> I would like linux to change to map the main exe with PROT_BTI when
> that is marked as BTI compatible. From the linux side i heard the
> following concerns about this:
> - it's an ABI change so requires some ABI bump. (this is fine with
>   me, i think glibc does not care about backward compat as nothing
>   can reasonably rely on the current behaviour, but if we have a
>   new bit in auxv or similar then we can save one mprotect call.)
> - in case we discover compatibility issues with user binaries it's
>   better if userspace can easily disable BTI (e.g. removing the
>   mprotect based on some env var, but if kernel adds PROT_BTI and
>   mprotect is filtered then we have no reliable way to remove that
>   from executables. this problem already exists for static linked
>   exes, although admittedly those are less of a compat concern.)
> - ideally PROT_BTI would be added via a new syscall that does not
>   interfere with PROT_EXEC filtering. (this does not conflict with
>   the current patches: even with a new syscall we need a fallback.)
> - solve it in systemd (e.g. turn off the filter, use better filter):
>   i would prefer not to have aarch64 (or BTI) specific policy in
>   user code. and there was no satisfying way to do this portably.
> 
> Other concerns about the approach:
> - mmap is more expensive than mprotect: in my measurements using
>   mmap instead of mprotect is 3-8x slower (and after mmap pages
>   have to be faulted in again), but e.g. the exec time of a program
>   with 4 deps only increases by < 8% due to the 4 new mmaps. (the
>   kernel side resource usage may increase too, i didnt look at that.)

i tested glibc build time with mprotect vs mmap
which should be exec heavy.

the real time overhead was < 0.2% on a particular
4 core system with linux 5.3 ubuntu kernel, which
i consider to be small.

(used PROT_EXEC without PROT_BTI for the measurement).


> - _dl_signal_error is not valid from the _dl_process_gnu_property
>   hook. The v2 set addresses this problem: i could either propagate
>   the errors up until they can be handled or solve it in the aarch64
>   backend by first recording failures and then dealing with them in
>   _dl_open_check. I choose the latter, but did some refactorings in
>   _dl_map_object_from_fd that makes the former possible too.
> 
> v2:
> - [1/6]: New patch that fixes a missed BTI bug found during v2.
> - [2-3/6]: New, _dl_map_object_from_fd failure handling improvements,
>   these are independent of the rest of the series.
> - [4/6]: Move the note handling to a different place (after l_phdr
>   setup, but before fd is closed).
> - [5/6]: Rebased.
> - [6/6]: First record errors and only report them later. (this fixes
>   various failure handling issues.)
> 
> Szabolcs Nagy (6):
>   aarch64: Fix missing BTI protection from dependencies [BZ #26926]
>   elf: lose is closely tied to _dl_map_object_from_fd
>   elf: Fix failure handling in _dl_map_object_from_fd
>   elf: Move note processing after l_phdr is updated
>   elf: Pass the fd to note processing
>   aarch64: Use mmap to add PROT_BTI instead of mprotect [BZ #26831]
> 
>  elf/dl-load.c              | 110 ++++++++++++++++++++-----------------
>  elf/rtld.c                 |   4 +-
>  sysdeps/aarch64/dl-bti.c   |  74 ++++++++++++++++++-------
>  sysdeps/aarch64/dl-prop.h  |  14 +++--
>  sysdeps/aarch64/linkmap.h  |   2 +-
>  sysdeps/generic/dl-prop.h  |   6 +-
>  sysdeps/generic/ldsodefs.h |   5 +-
>  sysdeps/x86/dl-prop.h      |   6 +-
>  8 files changed, 135 insertions(+), 86 deletions(-)
> 
> -- 
> 2.17.1
> 
