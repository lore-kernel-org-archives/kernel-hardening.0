Return-Path: <SRS0=izgj=5N=lists.openwall.com=kernel-hardening-return-18273-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357B3C43331
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 21:54:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 81A9C20732
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 21:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="alfNoYU8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81A9C20732
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18273-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10193 invoked by uid 550); 28 Mar 2020 21:54:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10170 invoked from network); 28 Mar 2020 21:54:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ovk2bmmHiHq0822krEgDFQkSPYt5Bktnb17JLm/lkJA=;
        b=alfNoYU8g+4LyDehhJH9iGwAtea55N/Xy8WHF5I5hMwcVa8EuZTEWAbZ7eeEAtCAjD
         1YoFtSlC3h2vBfbE0MPFBAhCW1HFfaZquUMB005WQh05V1HgCf9MnCioH/P0sUd516+4
         DI0bMW4XCbsmAoMIv05h5N0yfwlGhX5+NtqUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ovk2bmmHiHq0822krEgDFQkSPYt5Bktnb17JLm/lkJA=;
        b=eDq1SW262yPmhH/BVw5T6zT7AA2tMU+AgTF7Y0QVTCu1fgOvQ0tOasZsxhCjwHe23e
         mQIILBBeWIBz3La5kcDcpoeLJzd46uOnREfqJuhXUMJcaomK5hgHKTjufq6rhM1h9Uxa
         EelLpWpfnianGXIv7uCrpsFHBmWD6w+BRvBA6BlUIPVgbHGG7R3RwFwB/fRfmhHttwn0
         J2gdwvnM1i/YAQJGzHmtg5LjQRNF8/LqfxBOT5cIUnmkJ7C5p3he+YWTRuCyS91xNBrq
         27ojuMsSeNK0+M99BM+iyMr9fQ1ZOlVwhKAcNs6g0OntIdalxw1weZnCiMclOGpL+yTZ
         pGbw==
X-Gm-Message-State: ANhLgQ1WiTa0/I0M7FYMmDSWYC4pYVmP8dEPaHyXgQggwEClVG5Gr2DI
	MQ29eCPdOtsU8jj39u8B0v9AutgZ3BE=
X-Google-Smtp-Source: ADFU+vsfxLWSgTsJUgK14r0bXgUXWbEfwzw64SCYCXUXpSNDoac/nQTFCQ7zeikniIjgJ9mfpfaHkA==
X-Received: by 2002:a17:90a:fd90:: with SMTP id cx16mr7121093pjb.41.1585432431548;
        Sat, 28 Mar 2020 14:53:51 -0700 (PDT)
Date: Sat, 28 Mar 2020 14:53:49 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 7/9] proc: move hidepid values to uapi as they are
 user interface to mount
Message-ID: <202003281453.CED94974@keescook>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
 <20200327172331.418878-8-gladkov.alexey@gmail.com>
 <202003281340.B73225DCC9@keescook>
 <20200328212547.xxiqxqhxzwp6w5n5@comp-core-i7-2640m-0182e6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200328212547.xxiqxqhxzwp6w5n5@comp-core-i7-2640m-0182e6>

On Sat, Mar 28, 2020 at 10:25:47PM +0100, Alexey Gladkov wrote:
> On Sat, Mar 28, 2020 at 01:41:02PM -0700, Kees Cook wrote:
>  > diff --git a/include/uapi/linux/proc_fs.h b/include/uapi/linux/proc_fs.h
> > > new file mode 100644
> > > index 000000000000..dc6d717aa6ec
> > > --- /dev/null
> > > +++ b/include/uapi/linux/proc_fs.h
> > > @@ -0,0 +1,13 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > > +#ifndef _UAPI_PROC_FS_H
> > > +#define _UAPI_PROC_FS_H
> > > +
> > > +/* definitions for hide_pid field */
> > > +enum {
> > > +	HIDEPID_OFF            = 0,
> > > +	HIDEPID_NO_ACCESS      = 1,
> > > +	HIDEPID_INVISIBLE      = 2,
> > > +	HIDEPID_NOT_PTRACEABLE = 4,
> > > +};
> > > +
> > > +#endif
> > > -- 
> > > 2.25.2
> > > 
> > 
> > Should the numeric values still be UAPI if there is string parsing now?
> 
> I think yes, because these are still valid hidepid= values.

But if we don't expose the values, we can do whatever we like with
future numbers (e.g. the "is this a value or a bit field?" question).

-- 
Kees Cook
