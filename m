Return-Path: <SRS0=HPBG=5P=lists.openwall.com=kernel-hardening-return-18308-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1B8C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AD9B82072E
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uVCj1jls"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD9B82072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18308-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4011 invoked by uid 550); 30 Mar 2020 16:18:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3979 invoked from network); 30 Mar 2020 16:18:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3RZhMtylGsFHVN9z6+W/DO3tfjbONzUeU1vV8G94Wnk=;
        b=uVCj1jls1um+IFnFYAXlEl3lYn/Ft8+dWYk1a/M+NlIT0UWsnO21w6tRXOR7E3udoL
         Ea9iUXBC9QD3xlXfIV0f+bnx1i0FhuVFEtvoAyXjp4AYpxMNzWFCFTVrFLkQ9CqBdxNw
         sMa1pj4INgfN9HltvPVhFuhuco/8UchxZe+yQIKyI2ie99n7oqsz5lGk6w8gitTUAjNu
         n4S/uSQz97iyJRuJpzaNvs8wvDmy58c+p8rVUzBV2cxOJPIPfqM2wTJuLIfFXUE2s1w6
         8WR1vAvH095oLBBsEiydmU+7RTmiAyu76oqJpnM+vzj8QZIkqq56yeSKrztpvVVi1MnH
         0MpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3RZhMtylGsFHVN9z6+W/DO3tfjbONzUeU1vV8G94Wnk=;
        b=YF5OyesYCLJACTTBeKJ6RcUXlleVmL+D26Pw+ISRm5YyyPI6sjEMQkaX3AStjie0Fb
         1qtn/RtO++Z5xwdwFSEmoHe+gYBghxP5jzs/5iHzZgPuzdNUnLUULg9LCIrEDP16yRHi
         7FHP8d9z2tnKZEfjaNvZKjQBRdArnqceJ+po/EQSThYNuVQMkq1shZ9BZdWEHE6pdNDu
         28zlcHyuSEYVSYvT9ibjJw9zLzKblyGzXWZRNyeyBE0HsMsEfqeYjl5YgunfDAnICmKw
         jb51bBY9qRgHojNMrfV5T/MX6kZmWE2san8ZVhR27rQbdEP4kotB/xb7Pfz2DznxuXpN
         zDeA==
X-Gm-Message-State: AGi0Pub65HBX+s3IpW6RaDjNmkuXSXnK05J+WaEnXKrhvorj3krrAohc
	0ml4nVBcLyfqZcxtsqmeL+ZApcj8arBvwggZ5SfPaQ==
X-Google-Smtp-Source: APiQypJNEagMzxJZcGFrz+oawUKbPvEzaZGuQMq79eVbKwBRY/RuQbdk+smSuOeE886fsdULdjaPh0jzDG/oJseDM4w=
X-Received: by 2002:a2e:9d98:: with SMTP id c24mr7099656ljj.137.1585585079275;
 Mon, 30 Mar 2020 09:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
 <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 30 Mar 2020 18:17:32 +0200
Message-ID: <CAG48ez0ajun-ujQQqhDRooha1F0BZd3RYKvbJ=8SsRiHAQjUzw@mail.gmail.com>
Subject: Re: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf <bpf@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 30, 2020 at 5:59 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Mon, Mar 30, 2020 at 8:14 AM Jann Horn <jannh@google.com> wrote:
> >
> > I noticed that CONFIG_DEBUG_INFO_BTF seems to partly defeat the point
> > of CONFIG_GCC_PLUGIN_RANDSTRUCT.
>
> Is it a theoretical stmt or you have data?
> I think it's the other way around.
> gcc-plugin breaks dwarf and breaks btf.
> But I only looked at gcc patches without applying them.

Ah, interesting - I haven't actually tested it, I just assumed
(perhaps incorrectly) that the GCC plugin would deal with DWARF info
properly.
