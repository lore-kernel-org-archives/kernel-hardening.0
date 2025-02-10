Return-Path: <kernel-hardening-return-21941-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id E9D41C02198
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2025 04:30:06 +0000 (UTC)
Received: (qmail 29696 invoked by uid 550); 10 Feb 2025 04:29:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28651 invoked from network); 10 Feb 2025 04:29:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739161798; x=1770697798;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ke1mIKcFCXuM5xU3t6CrbyKLXX4Z0MhE5MCx3Zo5kTU=;
  b=EYVvyypNQZOhaE5189aFmBXrUQjUuPaCpzY8RkOXzALHqcHkFpM+F5B0
   g6F7qg3DECYO7CNOmBHdwBFf4+fYbqbrtkMR2aYYEhvmO8zX2GuksWW2p
   ASs0xGoV8IwmTHxNDMFM2JrJ/bn5isKLISBFAiF6WXdHYgSbKuXQN3Bfu
   AEkQhwhv5Xj/t6ke8PYh69R9Opr1IzV5CLJSsY0zHuMgANqNsn29RsGdI
   o+EIiPjdkUQXYylFfnysH1cZ6WqMspM2ggkl58Xt9Ph0ObLTljyH22IZM
   6mVmD/0/MPnTBoWdNQaPAyKsSyjtoXOm9JVyw9S0JU6i/O1CxEYqX7/Oa
   w==;
X-CSE-ConnectionGUID: kCGFRgYwRQes7410v91AHQ==
X-CSE-MsgGUID: 0FEGa+m8QmeuJ5WBBqq8Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11340"; a="43491836"
X-IronPort-AV: E=Sophos;i="6.13,273,1732608000"; 
   d="scan'208";a="43491836"
X-CSE-ConnectionGUID: QNZNtOYOQ3CbAViJvIfKSg==
X-CSE-MsgGUID: sJnpTm+fQ1m8C55P59UKKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,273,1732608000"; 
   d="scan'208";a="112590967"
Date: Sun, 9 Feb 2025 20:29:42 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>, linux-arch@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 1/1] x86: In x86-64 barrier_nospec can always be lfence
Message-ID: <Z6mAtkG9DnDDNFvn@tassilo>
References: <20250209191008.142153-1-david.laight.linux@gmail.com>
 <CAHk-=wiQQQ9yo84KCk=Y_61siPsrH=dF9t5LPva0Sbh_RZ0-3Q@mail.gmail.com>
 <20250209214047.4552e806@pumpkin>
 <CAHk-=wiSnNEWsvDariBQ4O-mz7Nc7LbkdKUQntREVCFWiMe9zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiSnNEWsvDariBQ4O-mz7Nc7LbkdKUQntREVCFWiMe9zw@mail.gmail.com>

> So on x86, both read and write barriers are complete no-ops, because
> all reads are ordered, and all writes are ordered. So those only need
> compiler barriers to guarantee that the compiler itself doesn't
> re-order them.
> 
> (Side note: earlier reads are also guaranteed to happen before later
> writes, so it's really only writes that can be delayed past reads, but
> we don't haev a barrier for that situation anyway. Also note that all
> of this is not "real" ordering, but only a guarantee that the
> user-visible semantics are AS IF they were actually ordered - if
> things are local in cache, ordering doesn't matter because no external
> CPU can *see* what the ordering was).

However in the local case *FENCE still orders, so it's actually not a
nop. Just normally you can't tell the difference in ordering semantics,
but it's visible in side effects like RDTSC.

-Andi
