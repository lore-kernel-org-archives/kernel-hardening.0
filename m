Return-Path: <SRS0=K8KR=EJ=lists.openwall.com=kernel-hardening-return-20330-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28293C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 15:05:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A433D20780
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Nov 2020 15:05:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="MuHw3TlN";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="MuHw3TlN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A433D20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20330-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23963 invoked by uid 550); 3 Nov 2020 15:05:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23937 invoked from network); 3 Nov 2020 15:05:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9wYgp+L8m5kvL9WmXlglilDVYKdhLJxZF/3QRzui7Y=;
 b=MuHw3TlNUxdFtRfKBFDlIyVYIzbRNjmOy0qdG4oqEcRH4oDLOB8sHq0DvBvamKhMwAT0JlXBA9YXOFwViC8w0+HLa7DHkElXrG2t0VcUimj2UEQ4Lt/XO3/RtPbJNtR36kmFtVoT5EsGOBmntZ4DnJ1I6n8dN3VQj+lSIW1xJng=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.openwall.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.openwall.com; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6132eefc32d8919c
X-CR-MTA-TID: 64aa7808
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZH3n9KkTEvUqifvMrz7b+oLpaxo6Pe5YqfoVSv+vVrlxnL2fK0sDt8yLJrOapCBoJskAbxi1j+k+V/zn5ouD4otOqETuPUgq/6re9AndCTPmmgyEUC6sgtF+Ka9Vdg6148Ms56TbTFMgO2sbWRqHUs/QCxGHcFWHf1LyDiJGPOueoPkZxWyXUCEdUDdltmXGzaLW/vFPsTnLMK/AjSKjmo7fExCDOpPO/5/J5h590WarFOeBOIiFdAn2ybJEoMEM1hv0XI4dypFM9xNH0TTSbHdhGXcxNZcT9J40dOiDvCe4tDg0FtTq7xP6lscQdUEJH/ewF+uL2OwLQHVjP80Vpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9wYgp+L8m5kvL9WmXlglilDVYKdhLJxZF/3QRzui7Y=;
 b=Ou7YRRvH494eVJBdu/nHPi6/m7e7BIvaXIjNuTEzWIZmR97sFxu+o16xw6OL05lHyXVho2hUb8sZaBiIH1PkFaW694Z2hH/J+cezVyndVWL32qDyw5IUvCqqcLM/Ph1op/cXY8IiPA1Ag7gEvHAAJteOq7DpjmutUmhjjvUCiWKOUhfZjP8ZDgQZTFNtx2fWvt5agR5aI58s6NUfHRvefjI3nx+qgly6F5OD2KDd33i4KkpqEfPsH9Jj4BMTRLjLEaXhmcTFWrR+4WkVtt4l9QTGIy/aDz2sKo+NauFoljiqGuaQ6yWquTD/5dfHk22WIgsa4OOpfk6GNLKsqvRPbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9wYgp+L8m5kvL9WmXlglilDVYKdhLJxZF/3QRzui7Y=;
 b=MuHw3TlNUxdFtRfKBFDlIyVYIzbRNjmOy0qdG4oqEcRH4oDLOB8sHq0DvBvamKhMwAT0JlXBA9YXOFwViC8w0+HLa7DHkElXrG2t0VcUimj2UEQ4Lt/XO3/RtPbJNtR36kmFtVoT5EsGOBmntZ4DnJ1I6n8dN3VQj+lSIW1xJng=
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
Date: Tue, 3 Nov 2020 15:04:12 +0000
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>,
	GNU C Library <libc-alpha@sourceware.org>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Topi Miettinen <toiwoton@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/4] elf: Move note processing after l_phdr is updated
 [BZ #26831]
Message-ID: <20201103150412.GA24704@arm.com>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <7b008fd34f802456db3731a043ff56683b569ff7.1604393169.git.szabolcs.nagy@arm.com>
 <87r1pabu9g.fsf@oldenburg2.str.redhat.com>
 <CAMe9rOpmiiBEZqLz-94_MEwgRky+EUsfd=X6Ue30H2c9R=dSKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMe9rOpmiiBEZqLz-94_MEwgRky+EUsfd=X6Ue30H2c9R=dSKQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.140.106.54]
X-ClientProxiedBy: LO2P265CA0103.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::19) To PR3PR08MB5564.eurprd08.prod.outlook.com
 (2603:10a6:102:87::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 29f77e01-3607-4a8e-7c34-08d88009d24d
X-MS-TrafficTypeDiagnostic: PA4PR08MB6095:|HE1PR0801MB1691:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<HE1PR0801MB1691749021EBB5C1EE483677ED110@HE1PR0801MB1691.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 qlWbCorgoT6LSd807f7NozlhXqrSHxdp9DMXUIsVemtCZZ8BiD1mE0SkBKGJ7OFsYpu5wkQIHkxOaDX2B82MLQw196q+5oob+HBZSLnktrbKDcyRgcgUd0KIlvP2MXf63bmczzXeLJ8PRuERkQCyWowzAxHaRu0p2b0dRAdo/m2oD+GnJDdgviRILA3FvNWvzSmVX/IAxtZEZc2lNXH2n6LjHnWnsb8px37Mp0IB5qhn/hdWEqCwrx+A9X69m8mw/qS7MyvRdfSH9glOOtZm+f7R2absgBTAlgEULgZ2xn1qAmu3QeCj6PMGXMSrmDGSQWGB4bWRDTXFtFE+e3ORTaSM8pidCk0XbobXJ8ruUiC91MZLsczHIDTCZLuMEM17IMo0t8On7TiZlk24WPqUMA==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5564.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(396003)(346002)(136003)(366004)(966005)(26005)(1076003)(5660300002)(6916009)(478600001)(186003)(316002)(54906003)(53546011)(8676002)(52116002)(36756003)(7696005)(83380400001)(2616005)(86362001)(2906002)(8886007)(16526019)(44832011)(8936002)(956004)(4326008)(7416002)(66946007)(55016002)(33656002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData:
 yoQcH15wDaLzHWNuTnNDRlSwEWVSNNy+BOiy+tKDItE4Ptl7Ii+jquJq8zNgb0H8LXtQzANLis5KyMHQ9xstCa/0vFpAU3qYeDkwNoF8iahh6mHqEVSeuznNaU3bvzV6ZfwscEyP8kLDPa8uQniOn1teHL6bHaGWkC47AcccLe+Ddy7m+7U6/HT0rHOdFFrmBw9ahSoXstKO/SDZnKzVrjhON4fpKDnn8OrXQNDxaLXidiPVpm9xMzxHC8+ElXRcc9/RAhQ849zWTEmwMashvQvI33mvBXhxooovysPNELvP/mn+VpgY0K3AjtZhJLmbJvfZra/QMJg266edz5M8Zd+hBszZXQcAtDVwOxWeui53qyoX3zG2SW1P3F3XqCDVxxOsK6ScS/WA8c1BY9ff89p21U6RQ3GsAtt/GSD3oqcW2+pSGf5k6DZFeMzx76RtVM2LB12ORHJNJfFBP+l4L9W+FbaYprwOR9U9iqTD2CQLrdw9h3plWmcu23sWLC7XZdLFQfaq+ZnLSyFcpqBUgzLGfR9mTMmP2pH2TuiXj+kSbJGnDMEgG0EhyonKqJKcc78jyy7s/aILxNTw0rluWmnqyjYg6Ajo2lNTT9Xiiv9D9MzDkTKF/0B3v4fELBQoNIorIQkRjd+vZvrFJrLBCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6095
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0392ab01-5aa7-471d-a031-08d88009ba49
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4HhvV4bo9nCndn7Go0B2SdA2m+lBTAjA73dfdvAzayQ5CZeaA9I/uklDc11jkX+qkcScbOlCxX16+Ay5MWDGxPS3cUCK95S8s+9hnYhSPUpqhW2pf/Fjyc5JCjNSZ3A+i/JY/griVy7kBCvp276DT3fFy5mRK0MBvRz7TlzOVaC8XzoXCLd4GWzMXYwATP8/JPzxyn/I8rMY4z68EST3J1oBBrzdW5ZDgX0DHumW5TVdgjcOscrecqW59yaLossYsG9pssPmSkmzSoo1AZ67xrXR5jC0BOg+3k0c5X5vMhrnGPrJ/9Bh+mJOedXq4jxRSEIIKSflrDURMi4UNaxIMNPdUA6qVQM2e+B7fl9GBBjq8ByMSXLbVz/V/IZCsGeTHNlXaj5ndrZwK24QwbivJ89q4y+Sv/Ah10IH7z3MD5xkVXcfRU4MvFGsNiQF4AhJ1YeozuuwsE4AFiEawWW3NQ==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39850400004)(136003)(376002)(46966005)(8886007)(33656002)(4326008)(336012)(82310400003)(86362001)(70586007)(70206006)(5660300002)(53546011)(2906002)(1076003)(36756003)(44832011)(478600001)(966005)(2616005)(956004)(356005)(47076004)(316002)(7696005)(8676002)(54906003)(82740400003)(107886003)(81166007)(186003)(8936002)(26005)(16526019)(55016002)(6862004)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 15:04:54.3679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f77e01-3607-4a8e-7c34-08d88009d24d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1691

The 11/03/2020 04:36, H.J. Lu wrote:
> On Tue, Nov 3, 2020 at 2:38 AM Florian Weimer <fweimer@redhat.com> wrote:
> > * Szabolcs Nagy:
> >
> > > Program headers are processed in two pass: after the first pass
> > > load segments are mmapped so in the second pass target specific
> > > note processing logic can access the notes.
> > >
> > > The second pass is moved later so various link_map fields are
> > > set up that may be useful for note processing such as l_phdr.
> > > ---
> > >  elf/dl-load.c | 30 +++++++++++++++---------------
> > >  1 file changed, 15 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/elf/dl-load.c b/elf/dl-load.c
> > > index ceaab7f18e..673cf960a0 100644
> > > --- a/elf/dl-load.c
> > > +++ b/elf/dl-load.c
> > > @@ -1259,21 +1259,6 @@ _dl_map_object_from_fd (const char *name, const char *origname, int fd,
> > >                                 maplength, has_holes, loader);
> > >      if (__glibc_unlikely (errstring != NULL))
> > >        goto call_lose;
> > > -
> > > -    /* Process program headers again after load segments are mapped in
> > > -       case processing requires accessing those segments.  Scan program
> > > -       headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
> > > -       exits.  */
> > > -    for (ph = &phdr[l->l_phnum]; ph != phdr; --ph)
> > > -      switch (ph[-1].p_type)
> > > -     {
> > > -     case PT_NOTE:
> > > -       _dl_process_pt_note (l, fd, &ph[-1]);
> > > -       break;
> > > -     case PT_GNU_PROPERTY:
> > > -       _dl_process_pt_gnu_property (l, fd, &ph[-1]);
> > > -       break;
> > > -     }
> > >    }
> > >
> > >    if (l->l_ld == 0)
> > > @@ -1481,6 +1466,21 @@ cannot enable executable stack as shared object requires");
> > >      /* Assign the next available module ID.  */
> > >      l->l_tls_modid = _dl_next_tls_modid ();
> > >
> > > +  /* Process program headers again after load segments are mapped in
> > > +     case processing requires accessing those segments.  Scan program
> > > +     headers backward so that PT_NOTE can be skipped if PT_GNU_PROPERTY
> > > +     exits.  */
> > > +  for (ph = &l->l_phdr[l->l_phnum]; ph != l->l_phdr; --ph)
> > > +    switch (ph[-1].p_type)
> > > +      {
> > > +      case PT_NOTE:
> > > +     _dl_process_pt_note (l, fd, &ph[-1]);
> > > +     break;
> > > +      case PT_GNU_PROPERTY:
> > > +     _dl_process_pt_gnu_property (l, fd, &ph[-1]);
> > > +     break;
> > > +      }
> > > +
> > >  #ifdef DL_AFTER_LOAD
> > >    DL_AFTER_LOAD (l);
> > >  #endif
> >
> > Is this still compatible with the CET requirements?
> >
> > I hope it is because the CET magic happens in _dl_open_check, so after
> > the the code in elf/dl-load.c has run.

i believe the note processing and later cet magic
are not affected by this code move.

but i did not test this with cet.

> 
> _dl_process_pt_note and _dl_process_pt_gnu_property may call
> _dl_signal_error.  Are we prepared to clean more things up when it
> happens?  I am investigating:

yeah, this is difficult to reason about.

it seems to me that after _dl_map_object returns there
may be _dl_map_object_deps which can fail in a way that
all of dlopen has to be rolled back, so if i move things
around in _dl_map_object that should not introduce new
issues.

but it is not clear to me how robust the dlopen code is
against arbitrary failure in dl_open_worker.

> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=26825
> 
> I don't think cleanup of _dl_process_pt_gnu_property failure is done
> properly.
> 
> -- 
> H.J.

-- 
