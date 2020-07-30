Return-Path: <SRS0=oSUh=BJ=lists.openwall.com=kernel-hardening-return-19500-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E160C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 17:27:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A58382072A
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 17:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="0Md3LILN";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="0Md3LILN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A58382072A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19500-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29775 invoked by uid 550); 30 Jul 2020 17:25:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32151 invoked from network); 30 Jul 2020 16:47:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6TQ1WvKcdKD1vO9QvW67/iJTr6UdXe18GT+VABVOeQ=;
 b=0Md3LILNS6uENpJuB6YvPwDb/4JU4s/7Ssh5vZJHkA6cKdPOSjvSkUt7DzEKKwVHpE2V/tjlWipWW645RQptYmsgu/0tAvgA6E7kr5+Zpz+FlGN5iUjctbQUIRipZmTokqAN4JZyCq7HMuPINzDJ2Z8vVaWXdVXoqTBBhG9zJCg=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 0a2ef7972e378601
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jr0x+6R4x8rhI/0gpJe66QMuy8WqeDFU4Q+BaVNbAzGix0lCIc1L2sSSNm3PWzmYS8Q4cFAhv+uCi0Ek55WPVj3HLuwnitTGiR+p8hvXy+ZbucoOLXWhC4Nqe8vk6lm6yImKec/gLzKx5+ySls2dgcaurB817e54GEbiKXqRHujitgtQhYZ7Emt7zSqUbDWCrWuD5vRrXITLGNAC3q3EhQSZdv8NkJl5i9O/dtNW8CkHCj4fMj65TKlopqRNPu/etDkfTsC1duy8onxhhIeTNy7CixaEm2aq1qvWc6BW6ZhXmE0NFnMLaIVRkVhERFim/mn/e+YdTGann5WWdBP2eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6TQ1WvKcdKD1vO9QvW67/iJTr6UdXe18GT+VABVOeQ=;
 b=GqZFGG1fUhsoP45tPwvfBlk8y5ffyfpumjje+DIdc0sDhdrpoFJEtQyyUP4AeIZF2wvHhYev3skyIUPvVxjbkWkOpD7vdDLrT3YjV5Y/J7N6SICWAsH+L/uM58HxIF7CaMkUZS2E1paZ3tirPISACeh4vyZBHq7QSTD56IIKXhYiM3HofyhSHVeucqqIhjDGi84YXGVIz1xNabU5ZybLY2DG8BHmUI18Hydh5X1yMUBcPkcikspu5IrJD4ZJy9r6aKv5fUe0e30tlpQTQXHbQQfWCugyBBmTaHnOpnqCX85brYKvNIKaAlpG8BIRerRhHZgf0Hhr2oDTnoKQ+0EpqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6TQ1WvKcdKD1vO9QvW67/iJTr6UdXe18GT+VABVOeQ=;
 b=0Md3LILNS6uENpJuB6YvPwDb/4JU4s/7Ssh5vZJHkA6cKdPOSjvSkUt7DzEKKwVHpE2V/tjlWipWW645RQptYmsgu/0tAvgA6E7kr5+Zpz+FlGN5iUjctbQUIRipZmTokqAN4JZyCq7HMuPINzDJ2Z8vVaWXdVXoqTBBhG9zJCg=
Authentication-Results-Original: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=arm.com;
Date: Thu, 30 Jul 2020 17:47:14 +0100
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Jann Horn <jannh@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, oss-security@lists.openwall.com,
	x86-64-abi@googlegroups.com,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Alternative CET ABI
Message-ID: <20200730164713.GF24636@arm.com>
References: <87k0ylgff0.fsf@oldenburg2.str.redhat.com>
 <CAG48ez3OF7DPupKv9mBBKmg-9hDVhVe83KrJ4Jk=CL0nOc7=Jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG48ez3OF7DPupKv9mBBKmg-9hDVhVe83KrJ4Jk=CL0nOc7=Jg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: LO2P265CA0413.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::17) To AM6PR08MB3047.eurprd08.prod.outlook.com
 (2603:10a6:209:4c::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-Originating-IP: [217.140.106.49]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64338ccb-2927-4cd8-56cf-08d834a83bba
X-MS-TrafficTypeDiagnostic: AM6PR08MB5000:|DB8PR08MB5084:
X-Microsoft-Antispam-PRVS:
	<DB8PR08MB5084760223E92572E248A1DEED710@DB8PR08MB5084.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
Content-Transfer-Encoding: quoted-printable
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 B9xfJZXIC33S+nPSaR0ftAs04Vw/qQaYi4CATNdIiW2LM2L/mH5qB96HqByPdHmBdr2pLfHznlVnGJFPdN2ljkk1QiYfymBTtrrxHBBMexwx6T36kwf+XZRPUidHqXwcE4FciOX0rUFuDAL0VrXEGUSVoF+A/qiaPtNWMihRXgm7hKOiE0LUnkPbfOm8PnH8btq5yRfJWrniDHHtwWpd6PPhUy37AX0DTumtsrHHK+gd46x1hl9j6m5n/XK6HRm9CELmy/6dOm6F0dU4LluJtnSfpRHNznhSwoS3GX3xZP6sPbnMbyG1G3sXmF/JSThSY3AluqMSWhWeXTASnwOuQQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3047.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(8886007)(478600001)(55016002)(44832011)(3480700007)(54906003)(316002)(1076003)(16526019)(2906002)(6916009)(186003)(2616005)(26005)(956004)(8936002)(8676002)(66476007)(7116003)(52116002)(53546011)(7696005)(66946007)(86362001)(83380400001)(5660300002)(4326008)(33656002)(36756003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 EOKm7TqLgcdc5dJqEgJYJGJnf5cLxV9wjE7BrMHrfn0jZ1uuggc8uul2QNh2FURjFivzslFwkmwTLGVT1htrtKB6XyiORdAejTdT0kMRQ/C/z6vVUE63zPsB0EueXiTvjgxx+dE8ws0rz6XK/g7qBfVZq1Qnmj0acjeDjaTnDQOi2lzgcNV4GLIeia3Cjz+2HuvfY2i6Td0eUFCsy1wWFxZcf25JW64GBV2K5YjNuMz+yvAe1jKB36sb3TQUzDUwTeiFDPn0zmxDDq3j4jAFeaFjbBWpuB3r8+Ui12DJQFXdY72Lim3L6pHvnd2PDSEs2cJPnEl1GxV/1EYr0YJUjZDGcbMTcK07yy29cb9pPjeSxMsAWXBNgri1/w1cHYcrg9DZ2aEOherQWim7aoRDl0eGox6D3JZLKrkj9H11XubkiFwOW4KRPLGNgdb7Aakgd1d446+IWZ5CsYSDz/XdQTeIhcBK3pv6bDSccvlOstgDtuE3+DOqDHReKmpVIslI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5000
Original-Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM5EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	20866a1a-49a5-45af-c2a5-08d834a83736
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DvtKFEp81f3NwkokPu14YZgQlT8Aha02ZewJyo9u+dncp3NF3Cdc88tdkllYqYlgU/GlC7NI+KacOSF2AJqp2KBPZ5p0sZSYsIubo4DSbpx0185mJ6u1UkUUSqFtK+FpU6f4f8L82oxy7eztDr1nn8MmiMn1Wgru1ahMfT1pQzqboagXtsuiDXWnF1xYjKaQeCeBz9hNz6s/61kkf0gAcqCDifGuApliFJTg3rIR6oSh7Uh6Z+LALHx35UoZNzV5hSyPa/brlwruuYJxvjXxNSNht7tx4XatA5Y8fOPE5ijeUvVTZBHR9eyWy7QvkR9ifuIn5zzp6HAAmJ14QCKShbKoRZjOvETpplxi282C6c6YG4XGhXZnVZUimeNBsbK6XPuh1yYeFPrnBx/O5E8mJQ==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966005)(83380400001)(7116003)(1076003)(53546011)(36756003)(8676002)(956004)(82310400002)(16526019)(47076004)(26005)(186003)(7696005)(82740400003)(8936002)(2616005)(33656002)(86362001)(44832011)(356005)(81166007)(3480700007)(316002)(4326008)(70206006)(70586007)(478600001)(6862004)(5660300002)(36906005)(336012)(54906003)(55016002)(2906002)(450100002)(8886007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 16:47:23.3404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64338ccb-2927-4cd8-56cf-08d834a83bba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM5EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5084

The 07/30/2020 18:41, Jann Horn wrote:
> On Thu, Jul 30, 2020 at 6:02 PM Florian Weimer <fweimer@redhat.com> wrote=
:
> > Functions no longer start with the ENDBR64 prefix.  Instead, the link
> > editor produces a PLT entry with an ENDBR64 prefix if it detects any
> > address-significant relocation for it.  The PLT entry performs a NOTRAC=
K
> > jump to the target address.  This assumes that the target address is
> > subject to RELRO, of course, so that redirection is not possible.
> > Without address-significant relocations, the link editor produces a PLT
> > entry without the ENDBR64 prefix (but still with the NOTRACK jump), or
> > perhaps no PLT entry at all.
>
> How would this interact with function pointer comparisons? As in, if
> library A exports a function func1 without referencing it, and
> libraries B and C both take references to func1, would they end up
> with different function pointers (pointing to their respective PLT
> entries)? Would this mean that the behavior of a program that compares

ld.so only needs to generate one plt entry
for a function in a process and that entry
can provided the canonical address that is
loaded from some got entry when the address
is used, so there is double indirection, but
it works.

> function pointers obtained through different shared libraries might
> change?
>
> I guess you could maybe canonicalize function pointers somehow, but
> that'd probably at least break dlclose(), right?
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
