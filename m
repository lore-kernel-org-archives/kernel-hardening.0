Return-Path: <SRS0=lj6T=C3=lists.openwall.com=kernel-hardening-return-19915-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63771C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 16:03:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30DC82388B
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 16:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="XrRM7bOK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30DC82388B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19915-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20121 invoked by uid 550); 18 Sep 2020 16:03:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20097 invoked from network); 18 Sep 2020 16:03:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1600444941;
	bh=vBPwxcUdsi4o0aVug2jOVM/F/yFtmhBYDt7JUWcG0A0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XrRM7bOK9K+s7eA/C16PMJBVT/FYkTJHx4nnMLkSCyTMnTupcKfaQMZ5dCRg1hH1b
	 VocOiWoVAngekfRkVpPQaYrpQOiPpoG284e8m6cV3Yc2hipps5s7wvjbuQHThqzNw7
	 ntybz8BMthfC+QN0/Oj3dWglheCra4yfvi5Gc+h8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 18 Sep 2020 18:02:16 +0200
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>,
	John Wood <john.wood@gmx.com>, Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] security/fbfam: Mitigate a fork brute force
 attack
Message-ID: <20200918152116.GB3229@ubuntu>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-7-keescook@chromium.org>
 <202009101649.2A0BF95@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009101649.2A0BF95@keescook>
X-Provags-ID: V03:K1:2SvK/7q6kc93vKtX72+ajY6DtC4s5Tf67gk8f8WTvUKUt0yy6yS
 bWPSrhLmQB7npp3vXdL/TyLUT9kQbwwrrZfRfnDRwSp+8qRRcA+fXHTMVkdm4AmR03DhlcT
 QqX38Q1njL5cy0I9fCNox//miQdNddfYUM3rnCM2NyzFLf1BfPTFPt56NIeVLPusWXCyQcR
 7R9iAboHfzD7xqTK+F1eQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:i5GlLK0cYNE=:1s08vLifTFmg+BEOjDGFi5
 22Ad1YK6+QNLtxlSkq5pkKg7XVeR9e2HKxcjmDi3C/HIot3ZjIByEX4RBsT4ZrNTplcxL0wDy
 h/e8s5hau+8S5xwzGup+qJi38bFhW2fHqOZxe3zCp55K2SXHmgO4sraRrAKWL/MGVFyjdp8p+
 /xItf/MKAJcPelDFvocze1869MD3Oud26TbrqgZP4z3mE8+OyTjtZd8phFis7bZZCwFOJhT2y
 h4Kwey5gy0rMjUYIlNn39mAXhwKkch+rcwuRw9JEc86r8pgnD/HYkHNkSwzjD3h3BXvPcl+W8
 Cqgb7l8flD4LCpA/9UaQFQCkXMs9i2DhaSFQEK13GeAmNyR6J834kjmbxePU7VospYOUfIZnh
 3d28uFmGlFK/q/BKHNLrGOeQzLyavWnx5O3vQLADaJxf4fcFJW4zSsCdys2Aiz9SXgzmQvDme
 XnDzeWERVf0OqwGkv73lEWGqOGih5p6lxEZ0l1QUJ8dr5O/D6wTvujEjABEX0iQUD0wNGljrG
 UguhTqqj6wVh5oHQlDy+hH54scHIHAVqdAo9biPHY5o/1oWzK1BDtpd/P00XNM1++Mmetjptc
 N2zskrnYs64Xpk6w06p2EDX5Ipyj5wUJ2y1i56lqEgt5mN0gjKJXJUM3IpJl5vaBI8Lo+7srs
 o/d1sSyH3AaHLLQA11+t3V34v6labQ+vjzIF7hOp20O4REXfBxw9/h0JVo8w19mwAXrlr+8T/
 /Ral/p+eVSyRA+WCo9CR6GDbAQsCtYf5xdtTB8GtJ6ZztxeQaEhUPcZwzKugEacTs4kGOyo7t
 a3uQyDtShUfiCMQEralPBIiKf+hnz3V6vv0KxeIpml6Drvdd+qNGSAdPRqGDWuD+t53aWUmR/
 v1p7py3bP1+U7g+UxJVuzgpZFHQ/hm8j6kRvs0L9PYghVPpQhKG2ZSF6aPAH0sX9ZioNEMyL8
 zSuHnCqjjml0tP+C7hige1PKmDhC24FKPl8bbj3t6QERFm3HJt1xEIZ8ECpBUEltJZEiQ6z3I
 4irn1Bp0YCjtSpyB92zgVj71wx4UbBVfhGeGA2jPkRCVb/8hQf254v4SdtsHN/5/EMGemVfpQ
 b2KIYnrFWLu9ySRnRWE+Dd65OFPUqy0mif7BBi9NcwqyGTpO8x3oqucuyRj9x+51uK7MH0PeV
 Rbx9pUJ+eNtR7tMHqXNSmTLV8xOzjBBUamNG9aqtsr+kd7lTOIy3masUwxVwprK4j+q7v0gqS
 zeythWoUQQBz80RzipghGPzKp6gDTESJadNpUXQ==
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2020 at 04:56:19PM -0700, Kees Cook wrote:
> On Thu, Sep 10, 2020 at 01:21:07PM -0700, Kees Cook wrote:
> >  /**
> > + * fbfam_kill_tasks() - Kill the offending tasks
> > + *
> > + * When a fork brute force attack is detected it is necessary to kill=
 all the
> > + * offending tasks. Since this function is called from fbfam_handle_a=
ttack(),
> > + * and so, every time a core dump is triggered, only is needed to kil=
l the
> > + * others tasks that share the same statistical data, not the current=
 one as
> > + * this is in the path to be killed.
> > + *
> > + * When the SIGKILL signal is sent to the offending tasks, this funct=
ion will be
> > + * called again during the core dump due to the shared statistical da=
ta shows a
> > + * quickly crashing rate. So, to avoid kill again the same tasks due =
to a
> > + * recursive call of this function, it is necessary to disable the at=
tack
> > + * detection setting the jiffies to zero.
> > + *
> > + * To improve the for_each_process loop it is possible to end it when=
 all the
> > + * tasks that shared the same statistics are found.
> > + *
> > + * Return: -EFAULT if the current task doesn't have statistical data.=
 Zero
> > + *         otherwise.
> > + */
> > +static int fbfam_kill_tasks(void)
> > +{
> > +	struct fbfam_stats *stats =3D current->fbfam_stats;
> > +	struct task_struct *p;
> > +	unsigned int to_kill, killed =3D 0;
> > +
> > +	if (!stats)
> > +		return -EFAULT;
> > +
> > +	to_kill =3D refcount_read(&stats->refc) - 1;
> > +	if (!to_kill)
> > +		return 0;
> > +
> > +	/* Disable the attack detection */
> > +	stats->jiffies =3D 0;
> > +	rcu_read_lock();
> > +
> > +	for_each_process(p) {
> > +		if (p =3D=3D current || p->fbfam_stats !=3D stats)
> > +			continue;
> > +
> > +		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_PID);
> > +		pr_warn("fbfam: Offending process with PID %d killed\n",
> > +			p->pid);
>
> I'd make this ratelimited (along with Jann's suggestions).

Sorry, but I don't understand what you mean with "make this ratelimited".
A clarification would be greatly appreciated.

> Also, instead of the explicit "fbfam:" prefix, use the regular
> prefixing method:
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Understood.

> > +
> > +		killed +=3D 1;
> > +		if (killed >=3D to_kill)
> > +			break;
> > +	}
> > +
> > +	rcu_read_unlock();
>
> Can't newly created processes escape this RCU read lock? I think this
> need alternate locking, or something in the task_alloc hook that will
> block any new process from being created within the stats group.

I will work on this for the next version. Thanks.

> > +	return 0;
> > +}
>
> --
> Kees Cook

Thanks
John Wood
