Return-Path: <SRS0=7IpX=VJ=lists.openwall.com=kernel-hardening-return-16424-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BFCC742C2
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 13:56:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4B158208E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 13:56:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="QYqkLEGF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B158208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16424-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15423 invoked by uid 550); 12 Jul 2019 13:56:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15401 invoked from network); 12 Jul 2019 13:56:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WDiv0t+R3uRl5W7qmXtAoSiEHEHdxKx4ml5mjXWh+Pg=;
        b=QYqkLEGFA1/hJ7msrSJEUejaFTfoP3QzQQ0XbAHmT9Csl4VlQGRIXmlO2ywQXQvND+
         Hrz0eSA/du87KWMiWhvfsSxGBDZW8Y6Afvn5Q1TceLQvp9r9CvlEbDnZIeTmNrviry7U
         wYHovwF3+TslYJyFDr+Shjrc4RZtnIq4XuqVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WDiv0t+R3uRl5W7qmXtAoSiEHEHdxKx4ml5mjXWh+Pg=;
        b=MuVNhh+4tcvIKu1e/0punT9PhQ+kXR2tWanh8HXQ7qEy+m1Q1xpofcwi28L42LaKil
         P970T2JvFuPIuFNYhnP8F86e+RxRA5X9G2eBa8/MMhsknXysnlZd4Hqm9i67Vwrb/uB3
         TlBVGO9jA0038EKxn3xA8KK6SimEz9qqfgwqTmi5xhtteqO8BKq3sqZf1GOCg/3ixv1E
         6mCTy36rnbe8NmkJu3cuSQJIxs9BN9c3MXq7wMqrAA6cQzMMHb6me7B7/01e5SQ78EAh
         ZD44P1vgOksYm80ep/lQ7ixbGNsz7sX2+Wjk14pdsp9HxaD+AXMEnZjRDc7U9san+WAy
         EaFw==
X-Gm-Message-State: APjAAAU2ePdqjhS1TZ3Fw5K6buKHI/pKyS/oPK78zKHLleaqlaW9mtxv
	oVKQ/ngT8Qf2Ghine6AFGok=
X-Google-Smtp-Source: APXvYqzJEhVDBzSiRVeb97C/BOIrGCC92lhrBy1TO8FxsLTYA0YSdLtl7eAeD1UPch8SID4lyw/Qag==
X-Received: by 2002:a63:b1d:: with SMTP id 29mr11024618pgl.103.1562939792240;
        Fri, 12 Jul 2019 06:56:32 -0700 (PDT)
Date: Fri, 12 Jul 2019 09:56:29 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712135629.GH92297@google.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712121200.GC21989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121200.GC21989@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jul 12, 2019 at 02:12:00PM +0200, Oleg Nesterov wrote:
> On 07/11, Joel Fernandes (Google) wrote:
> >
> > +int rcu_read_lock_any_held(void)
> 
> rcu_sync_is_idle() wants it. You have my ack in advance ;)

Cool, thanks ;)

- Joel
