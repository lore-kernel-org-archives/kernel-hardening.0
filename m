Return-Path: <kernel-hardening-return-21955-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 305FCC8303F
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Jul 2025 11:58:45 +0000 (UTC)
Received: (qmail 3593 invoked by uid 550); 2 Jul 2025 11:58:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3570 invoked from network); 2 Jul 2025 11:58:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a2F3v23nGGvWezK05/iV6yxFAQUOzEJwGb9ANejg6zA=; b=rL/G1vx2Eqz7cRfP7lsxF2+MOi
	5QhTYbv9rLZhVkGtfooao56tbrof8LE3xjCz05wo82q3Tw5ziNC8plOcYegwUqXUt8+/C7ANTpKzr
	NaI01UMZQRWF697cuk8D72m06Nwjowa524R+C9LR9VktC+Tf6aY2kgFQj0UkWhRlEWahtDUwRT+JF
	Zh6wkjvvmAVswOQBp3EQ9nFC6avYA26mw4Acef3SB+YkeSheQaaHqMpJ0x4fEO8NF9RTHuL7ZNzVh
	ASyKjsiowVRhACZrQxCyhfLL6lSbEdaw41MqLdkT4rkcGV//Vt1CRI+huHALrhUpYMMd9vOPEuDan
	hAkQfZRg==;
Date: Wed, 2 Jul 2025 13:58:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Serge Hallyn <serge@hallyn.com>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	linux-perf-users@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	James Morris <jamorris@linux.microsoft.com>
Subject: Re: uprobes are destructive but exposed by perf under CAP_PERFMON
Message-ID: <20250702115814.GA1099709@noisy.programming.kicks-ass.net>
References: <CAG48ez1n4520sq0XrWYDHKiKxE_+WCfAK+qt9qkY4ZiBGmL-5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1n4520sq0XrWYDHKiKxE_+WCfAK+qt9qkY4ZiBGmL-5g@mail.gmail.com>

On Tue, Jul 01, 2025 at 06:14:51PM +0200, Jann Horn wrote:
> Since commit c9e0924e5c2b ("perf/core: open access to probes for
> CAP_PERFMON privileged process"), it is possible to create uprobes
> through perf_event_open() when the caller has CAP_PERFMON. uprobes can
> have destructive effects, while my understanding is that CAP_PERFMON
> is supposed to only let you _read_ stuff (like registers and stack
> memory) from other processes, but not modify their execution.
> 
> uprobes (at least on x86) can be destructive because they have no
> protection against poking in the middle of an instruction; basically
> as long as the kernel manages to decode the instruction bytes at the
> caller-specified offset as a relocatable instruction, a breakpoint
> instruction can be installed at that offset.
> 
> This means uprobes can be used to alter what happens in another
> process. It would probably be a good idea to go back to requiring
> CAP_SYS_ADMIN for installing uprobes, unless we can get to a point
> where the kernel can prove that the software breakpoint poke cannot
> break the target process. (Which seems harder than doing it for
> kprobe, since kprobe can at least rely on symbols to figure out where
> a function starts...)
> 
> As a small example, in one terminal:

Urrggh... x86 instruction encoding wins again. Awesome find.

Yeah, I suppose I should go queue a revert of that commit.
