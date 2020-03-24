Return-Path: <SRS0=3OJ6=5J=lists.openwall.com=kernel-hardening-return-18210-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A13C10DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:22:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B77C42070A
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TU+v6vgT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B77C42070A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18210-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26179 invoked by uid 550); 24 Mar 2020 21:22:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26159 invoked from network); 24 Mar 2020 21:22:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K0AQOrscsNAyPOgnjIz1wdZ8BwbWscK7BvSW7dZFNMU=;
        b=TU+v6vgTqqL8DSRyHNIS3zPA2Au3s8bOdz4RjYVrI59y/xJG37DuCzUkFedo8prEM1
         kEhbDC8RUbuZ44J4woqibSX2DnsCF77IrNvFFBgUdsgFnP87BEfOj65kKyLU5UPa/XiH
         yLDUovevdVM9pFj6antE7mF1/9gnUPays5DSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K0AQOrscsNAyPOgnjIz1wdZ8BwbWscK7BvSW7dZFNMU=;
        b=St9eoC3tzdXN0XowmoYAGf6but9NrZnJK8wAc2rlSh2gpQlsdhXYa5dR19hnAVVamc
         zSkQY3z+q3y+Bk4BUXtGWikWFtdec8573yL/RPw/HhrjgGzRIT2STh1UR1fbSlKwbJep
         ke6GdfloHYoRcSRdTrFcDj+MdgIt9Qv1pBR2ptKMHh/SsgLpCS2WiQoDplDCEtS9HglM
         oLWgpceGWB4c0RHRptSdxu9E1XTKJajBqZK/Xev7QQMJMOFVhT1inQ8+4jmjifLkUhNj
         W3qbt2SxZPA/OzntrnZKg5tkHeZ74bg5iFOQpdBUqH886D42hfTrVQ/yjgfGYbB7pOkf
         t7/Q==
X-Gm-Message-State: ANhLgQ3tRfpcEg6S2T+zkoJhJ+4aiyYdUwpUii7rYwrTN2XQvcKuGJG5
	NsXq4EmSt2fm+7Y5QQ5fxgXgjdGLJfs=
X-Google-Smtp-Source: ADFU+vvtiEVcQCUDBk/k7UW6E5ar5AKay34b/rDgiA/uD8SK7RpZg6Wfy8oeWgK+GdAIf54qpdAXxw==
X-Received: by 2002:a2e:9f07:: with SMTP id u7mr12777864ljk.115.1585084936622;
        Tue, 24 Mar 2020 14:22:16 -0700 (PDT)
X-Received: by 2002:a19:f015:: with SMTP id p21mr60990lfc.10.1585084934903;
 Tue, 24 Mar 2020 14:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200324204449.7263-1-gladkov.alexey@gmail.com> <20200324204449.7263-4-gladkov.alexey@gmail.com>
In-Reply-To: <20200324204449.7263-4-gladkov.alexey@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Mar 2020 14:21:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXbgW7-FYL4Rkaoh8qX+CkS5saVGP2hsJPV0c+EZ6K7A@mail.gmail.com>
Message-ID: <CAHk-=whXbgW7-FYL4Rkaoh8qX+CkS5saVGP2hsJPV0c+EZ6K7A@mail.gmail.com>
Subject: Re: [PATCH RESEND v9 3/8] proc: move hide_pid, pid_gid from
 pid_namespace to proc_fs_info
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Alexey Gladkov <legion@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, 
	"Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	"J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 24, 2020 at 1:46 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> +/* definitions for hide_pid field */
> +enum {
> +       HIDEPID_OFF       = 0,
> +       HIDEPID_NO_ACCESS = 1,
> +       HIDEPID_INVISIBLE = 2,
> +};

Should this enum be named...

>  struct proc_fs_info {
>         struct pid_namespace *pid_ns;
>         struct dentry *proc_self;        /* For /proc/self */
>         struct dentry *proc_thread_self; /* For /proc/thread-self */
> +       kgid_t pid_gid;
> +       int hide_pid;
>  };

.. and then used here instead of "int"?

Same goes for 'struct proc_fs_context' too, for that matter?

And maybe in the function declarations and definitions too? In things
like 'has_pid_permissions()' (the series adds some other cases later,
like hidepid2str() etc)

Yeah, enums and ints are kind of interchangeable in C, but even if it
wouldn't give us any more typechecking (except perhaps with sparse if
you mark it so), it would be documenting the use.

Or am I missing something?

Anyway, I continue to think the series looks fine, bnut would love to
see it in -next and perhaps comments from Al and Alexey Dobriyan..

            Linus
