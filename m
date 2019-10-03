Return-Path: <SRS0=NYVR=X4=lists.openwall.com=kernel-hardening-return-16988-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E1BC10F14
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Oct 2019 21:36:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EC1682133F
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Oct 2019 21:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mZW7Sgt5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC1682133F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16988-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1177 invoked by uid 550); 3 Oct 2019 21:36:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1142 invoked from network); 3 Oct 2019 21:36:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kqOYKHKNUC13kHadGlANh1RJE237NSBnH9JSUC2Q9B8=;
        b=mZW7Sgt56JQ03FlRP1y/Z+Sgr39HCXVbo9AusuZKgffE/oEi6rd00b2JhixZPXime0
         nYr1H9JLQ/lmJUQdnz1LpAY4K86PhKOW0l40P6hV0JOmMBLcYPkS4jqB6tg/uv7MhNWx
         46tiO14AAqVbHsLNrJQW+fmmQdyB4/f1TUcTE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kqOYKHKNUC13kHadGlANh1RJE237NSBnH9JSUC2Q9B8=;
        b=Ab8EAUTXaK/dmAVHM4gCKqQC6Sx579yHUV+NKxViCpiyOMRKiHXCA5vCu5XhkKhMv1
         Gzbogwprkn5x4wwDOOpMrZQE9UicEu1rNhw3fali3ffbtAypx5fUMV6JrvRr0VAa/QMo
         8AynMq/R222yKrvv0hVKsMj/XAa7BrYTUB1YximFVQXzMFEu9pU+gKjCczpyMw3UCItn
         L4e23NqYhdyXyvoX4dA6PAibPMtCY4OwZ+ijtkR8I1OwUOB1pYonl9jv75HnRT1fuO5r
         KH49nKhtP3jhh2Yy+7SMkkDAmsGeFig2aYVDOmzpcjWyef/FB9uCN56IAVWBm+UepnDi
         8Wtg==
X-Gm-Message-State: APjAAAW01k+7FZ+2HQ+8+i1fjTasa1S2Lp7b1B+72TOTQcNRm5ZwEhNm
	hRooLgfkFfo9Qv1cCRnqrZv4AA==
X-Google-Smtp-Source: APXvYqzbcD3PFGZrtDmhCMglRZt6aOa8c4NClWxRAUxX0QDenmZZ5ed5Khuzi31Xuami1Ss72VJ37g==
X-Received: by 2002:a17:90a:c8a:: with SMTP id v10mr12592864pja.6.1570138569548;
        Thu, 03 Oct 2019 14:36:09 -0700 (PDT)
Date: Thu, 3 Oct 2019 14:36:07 -0700
From: Kees Cook <keescook@chromium.org>
To: Muni Sekhar <munisekharrms@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: How to get the crash dump if system hangs?
Message-ID: <201910031417.2AEEE7B@keescook>
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook>
 <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>

On Thu, Oct 03, 2019 at 10:18:48PM +0530, Muni Sekhar wrote:
> Thanks a lot for letting me know about pstore, will try this option.
> It will be helpful if you can share some pointers on 'how to enable
> software ECC'?

When I boot with pstore, I use a bunch of command line arguments to test
all its feature:

ramoops.mem_size=1048576
ramoops.ecc=1
ramoops.mem_address=0x440000000
ramoops.console_size=16384
ramoops.ftrace_size=16384
ramoops.pmsg_size=16384
ramoops.record_size=32768

but I'm using pmem driver to reserve the 1MB of memory at 0x440000000.

To do a RAM reservation on a regular system, you'll need to do something
like boot with:

memmap=1M!1023M

which says, reserve 1MB of memory at the 1023M offset. So this depends
on how much physical memory you have, etc, but you'll be able to see the
reservation after booting in /proc/iomem. e.g. for me, before:

...
00100000-bffd9fff : System RAM
...

with memmap:

...
00100000-3fefffff : System RAM
3ff00000-3fffffff : Persistent Memory (legacy)
40000000-bffd9fff : System RAM
...

So in that example, the address you'd want is 0x3ff00000

memmap=1M!1023M
ramoops.mem_size=1048576
ramoops.ecc=1
ramoops.mem_address=0x3ff00000
ramoops.console_size=16384
ramoops.ftrace_size=16384
ramoops.pmsg_size=16384
ramoops.record_size=32768

In dmesg you should see:

[    0.868818] pstore: Registered ramoops as persistent store backend
[    0.869713] ramoops: using 0x100000@0x3ff00000, ecc: 16

And if that address lines up with the "Persistent Memory (legacy)" line
in /proc/iomem you should be good to go.

Just mount /sys/fs/pstore and see if the console dump updates between
warm boots, then try some cold boots, see if the ECC works, etc.

Good luck!

-- 
Kees Cook
