Return-Path: <SRS0=d828=JG=lists.openwall.com=kernel-hardening-return-21184-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7306CC433B4
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 14:30:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 92AEB61042
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 14:30:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92AEB61042
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21184-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11364 invoked by uid 550); 9 Apr 2021 14:30:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11332 invoked from network); 9 Apr 2021 14:30:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1617978588;
	bh=5O1wMd5mUgPkJTBj4O3BQ9Lppim90qlc+Qa25QgQ/aw=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eKUVT2Ddv19Ta027w6sZNo4hWC2Am1KyJfCsg7t5DTp1tWWiK5oEOP/pA0HQorj3i
	 cAsdspDRlEz4S1AOPZTaKFroIM904npBYaQaTh9UwdqveOUaGrFkbUMx0AdFPoprGK
	 jlF4zaCVU8bFCbf+jXGsL9YM/TMNgCcZFDE9z64w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 9 Apr 2021 16:29:33 +0200
From: John Wood <john.wood@gmx.com>
To: Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
	Andi Kleen <ak@linux.intel.com>
Cc: John Wood <john.wood@gmx.com>, kernelnewbies@kernelnewbies.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
Message-ID: <20210409142933.GA3150@ubuntu>
References: <106842.1617421818@turing-police>
 <20210403070226.GA3002@ubuntu>
 <145687.1617485641@turing-police>
 <20210404094837.GA3263@ubuntu>
 <193167.1617570625@turing-police>
 <20210405073147.GA3053@ubuntu>
 <115437.1617753336@turing-police>
 <20210407175151.GA3301@ubuntu>
 <184666.1617827926@turing-police>
 <20210408015148.GB3762101@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408015148.GB3762101@tassilo.jf.intel.com>
X-Provags-ID: V03:K1:YPKwDhVBw/7VScW1HdArPouip4RWatqmh89vsEj7rJfAlT40767
 HGFvEEv5AXYSbvMtIVjyPeTtHnVicUW04cWWEwjRcoiTK40M5zNj415xpL6yh3W/c20t40U
 51/jJ8CNfwnrcjDKBD5GdL/u1s+R0dzViZsJcN09B7bsT3V84hQncA8uVIzQLdD5gOmCi6Q
 irLcehpwkYHa/O9oEJbxg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:VjK5cFzAIUs=:GUiH48WFHw4gs6pbKzr5IW
 L99yT6xhg1CUxI+jEvXvwrPb3BEk//xYyXpH6wxALEzKI8N/sQYNBKhiVil4zEHgz2SYJhcsl
 1MaUlkYmsY15VMCtXjocOGYPHXjNNK/d9QucLBPENUOhnV4wP1BTPbKWmnK60coUdVO/z1aBY
 ZRdt8WDondQfagTdHXnXpVpFUiwwE8exFq5vBH5K6LctgEL9V8SyawwcW96ByZdXAxi1anJdA
 J3bPdNcoc566VHy859812mnrwTtdx5J6mGxjVwYwLR3GfkNMc9XgvmoZ4/FXwgBddslAFSHx5
 fbJMsr/UQhqDv/vRPzafK/dAvcfNeq0yPb5EhHN0Gyj7krNDwCxqlhFTcK3TWD76PY9UrMGy4
 REWCgiNZ3rHl8AsnoSnPRL+SDpExdr25EPB6kFEACtVzJelhg+D9g4noV6X1U+87RCg48JwLP
 BpmMF93Z8YWSiJ1IqBAbiU5Q1Fv9cW66kFPR++ZcC9OXdBfAV11zEhQihkyNhhss8BdS7IWy8
 fi39MCtpAa2YMUYLxqLDA4qwC4zHEIJlGF3hGMtor187TMMG5rpPzLl7EmpTyvXqKWNg4s5yG
 tJgPH+3xR7+gyLB+cCrXT/zxGnJZr9zxsVXYEHwRTxHqWe64IjlU/obXOi01JQHgZxupnK4ox
 5I3CMxKKZcYJv0C3X/3X2M0LpdXhNkiex1StqeGUwPU7IfVSept+Zp/0dHhz8U/J7H6GjVXpj
 5dKfmf4xnUnsvT3JzudR10a8KHN7JOLR9TRwtOnYYkDfNUsCGskFvY0F+rL/9+RmkZ+bWVHs8
 +rPD9r7ny2WilLiG33fzGEk5sWfTU4SlofA2a66GWbykP9uCkpff6hFuVGnKlQsj95wDAw8dc
 XeiCpup3qOurw92O8TM/R15na/ZyoTSYtZzmaqjQR2RRYHFA3X9WCjmsHbb3UQSEoKfdD2OcT
 LcD2r3BtqcOPiPHN/pQhru/h9ioNVE5Abr+PRtoEKqMSlbRFC+PziSi3vchid4RMtFlBUODkw
 7uzZa4zSQqZztgCZwc0dwFD+abSta4GSUKRo6AXBj1bUpxPWRVNvc3u4rhjcMzrQWyZlDwpH6
 ytCddyEhsl8huw3kbu6AoiMThIpEpuqoA72GK4ucR30r0qmn2iGlMWCkXZMWGsFjanm4O7ENO
 OsXdSdSkPmWQiLkMiZeVU9Lt1aknkxCveNFqZjM1RdHccE59D5xsjqbf2C8K3CO9QfJes=
Content-Transfer-Encoding: quoted-printable

Hi Valdis and Andi. Thanks for your comments.

On Wed, Apr 07, 2021 at 06:51:48PM -0700, Andi Kleen wrote:
> > I didn't even finish the line that starts "From now on.." before I sta=
rted
> > wondering "How can I abuse this to hang or crash a system?"  And it on=
ly took
> > me a few seconds to come up with an attack. All you need to do is find=
 a way to
> > sigsegv /bin/bash... and that's easy to do by forking, excecve /bin/ba=
sh, and
> > then use ptrace() to screw the child process's stack and cause a sigse=
gv.
> >
> > Say goodnight Gracie...
>
> Yes there is certainly DoS potential, but that's kind of inevitable
> for the proposal. It's a trade between allowing attacks and allowing DoS=
,
> with the idea that a DoS is more benign.
>
> I'm more worried that it doesn't actually prevent the attacks
> unless we make sure systemd and other supervisor daemons understand it,
> so that they don't restart.

I'm working on it. I will send a formal proposal in the next version.

> Any caching of state is inherently insecure because any caches of limite=
d
> size can be always thrashed by a purposeful attacker. I suppose the
> only thing that would work is to actually write something to the
> executable itself on disk, but of course that doesn't always work either=
.

I'm also working on this. In the next version I will try to find a way to
prevent brute force attacks through the execve system call with more than
one level of forking.

> -Andi

Again, thank you very much.
John Wood
