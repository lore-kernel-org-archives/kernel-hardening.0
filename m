Return-Path: <SRS0=gGqz=GM=lists.openwall.com=kernel-hardening-return-20622-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE6BC433DB
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 17:06:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0A2952343F
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 17:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A2952343F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20622-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1883 invoked by uid 550); 9 Jan 2021 17:06:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1863 invoked from network); 9 Jan 2021 17:06:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610211968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=joUlfz99h/FvbQhyQ1sXKa4tTuoivxwQKiFtAkkLoGE=;
	b=S4/Yeg+xUxWPxccd5/Zr1OD0OeoJeEml8KhPTKNp5Gh059lluMNWm3fe/B3MT9XqIHoh4G
	QBOpX5mMFJtKAR1DV1/uoxXbn/71iqjzUSV5EDKMBLb16QKHlH33ebDudLROqAJI0qtIm/
	xd3YbCyDVfRdGhg1gCvlefWyW+8xxRY=
X-MC-Unique: s4qYlsTrNKOXjyTgnesYQQ-1
Date: Sat, 9 Jan 2021 11:05:58 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v9 00/16] Add support for Clang LTO
Message-ID: <20210109170558.meufvgwrjtqo5v3i@treble>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
 <20210109153646.zrmglpvr27f5zd7m@treble>
 <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
 <20210109160709.kqqpf64klflajarl@treble>
 <CA+icZUU=sS2xfzo9qTUTPQ0prbbQcj29tpDt1qK5cYZxarXuxg@mail.gmail.com>
 <20210109163256.3sv3wbgrshbj72ik@treble>
 <CA+icZUUszOHkJ8Acx2mDowg3StZw9EureDQ7YYkJkcAnpLBA+g@mail.gmail.com>
 <20210109170353.litivfvc4zotnimv@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210109170353.litivfvc4zotnimv@treble>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

On Sat, Jan 09, 2021 at 11:03:57AM -0600, Josh Poimboeuf wrote:
> On Sat, Jan 09, 2021 at 05:45:47PM +0100, Sedat Dilek wrote:
> > I tried merging with clang-cfi Git which is based on Linux v5.11-rc2+
> > with a lot of merge conflicts.
> > 
> > Did you try on top of cfi-10 Git tag which is based on Linux v5.10?
> > 
> > Whatever you successfully did... Can you give me a step-by-step instruction?
> 
> Oops, my bad.  My last three commits (which I just added) do conflict.
> Sorry for the confusion.
> 
> Just drop my last three commits:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-vmlinux
> git checkout -B tmp FETCH_HEAD
> git reset --hard HEAD~~~
> git fetch https://github.com/samitolvanen/linux clang-lto
> git rebase --onto FETCH_HEAD 79881bfc57be

Last one should be:

git rebase --onto FETCH_HEAD 2c85ebc57b3e

-- 
Josh

