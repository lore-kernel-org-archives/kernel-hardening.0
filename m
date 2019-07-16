Return-Path: <SRS0=wclf=VN=lists.openwall.com=kernel-hardening-return-16477-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595D0C76192
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:35:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ACE762173E
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:35:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="BtxFNZrJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACE762173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16477-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32091 invoked by uid 550); 16 Jul 2019 18:35:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32071 invoked from network); 16 Jul 2019 18:35:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qAKhev+MhcsyOVuReyPGPlfwr6RAqsm8KLJC/p+tBWo=;
        b=BtxFNZrJ1lxuLHdz4p0cb5NpRBas4oMeXYrSpaXChm3f5inh99nI5E+MdCjO+0SvFN
         Ry8bf1i9hikIL8m72cMNN8wnWLsm9KfRlPPMZ5RjfBcQEkIc6IujCMbAsuy+mISYcuee
         Qr4kYdcFcd5XUHZrH7KXQ8HM3/IMx446SBoQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qAKhev+MhcsyOVuReyPGPlfwr6RAqsm8KLJC/p+tBWo=;
        b=lsr8rlLKAWEduhBrl870yU3a6Jc9OdKt0GGxl+QazpTmewErPHVlH/LF8BrfmSR5Ce
         VerjRWpH6CCDhmD2TlYFtqzHVLDchBD2YBg87q6aYfcB9vNkDGO5ZaS9wjhJeF3I99TS
         4YebMN9W/VsSuFwt8xdtFjpHNBToPFiB8u/1ivcE3g84bTjl373Rs9LLAzgdWDssXD0e
         pV7uzuByIswYx2tWLTfJUMhpMXtQlkM6tyMYVu1fZV+Qaolrkd5kncmz896YG3ZDJsIM
         fcPk35oWHVIaqaUZQf7NyfUBOoyON7a351s4QGBCdBLjCeHkK+Jhg/TBmYDSpzyUK9A2
         uvRw==
X-Gm-Message-State: APjAAAUg36CxmLZyI12eTChJfExqjBzaPr9YNS1VA+XxbuoOl0lwIfc3
	j9NFdw5P90RmMEEwFzcHbzY=
X-Google-Smtp-Source: APXvYqyfCs9+aKdxQJQ7pxXZdVPAjoPO3h0r2nncpS7RMorjmeD2xnNucSDVGhLwrY66fVK+0eWNvA==
X-Received: by 2002:a17:902:b603:: with SMTP id b3mr38238048pls.9.1563302119843;
        Tue, 16 Jul 2019 11:35:19 -0700 (PDT)
Date: Tue, 16 Jul 2019 14:35:17 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com, kernel-team@android.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 2/9] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190716183517.GA129705@google.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-3-joel@joelfernandes.org>
 <20190716182237.GA22819@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716182237.GA22819@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 16, 2019 at 11:22:37AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 12, 2019 at 01:00:17PM -0400, Joel Fernandes (Google) wrote:
> > This patch adds support for checking RCU reader sections in list
> > traversal macros. Optionally, if the list macro is called under SRCU or
> > other lock/mutex protection, then appropriate lockdep expressions can be
> > passed to make the checks pass.
> > 
> > Existing list_for_each_entry_rcu() invocations don't need to pass the
> > optional fourth argument (cond) unless they are under some non-RCU
> > protection and needs to make lockdep check pass.
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> If you fold in the checks for extra parameters, I will take this
> one and also 1/9.

I folded the checks in and also threw in the rcu-sync with Oleg's ack:

Could you pull into /dev branch?

git pull https://github.com/joelagnel/linux-kernel.git list-first-three
(Based on your dev branch)

