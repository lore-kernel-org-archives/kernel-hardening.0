Return-Path: <SRS0=YIjS=IF=lists.openwall.com=kernel-hardening-return-20888-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAC8C433DB
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Mar 2021 22:49:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 348AC6515E
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Mar 2021 22:49:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 348AC6515E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20888-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11694 invoked by uid 550); 7 Mar 2021 22:49:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11659 invoked from network); 7 Mar 2021 22:49:42 -0000
IronPort-SDR: DUl4kZ7PQNH86EdS54fpxS+aTMPauymzcVTP52aYvHmk1cf6VOZlb4sWMAH+VdTnjTTeXqdCdc
 T64XTZuIbtdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="249316695"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="249316695"
IronPort-SDR: kI7WKMsUaHp8xr+jCSAFZ0FdFoCwULV7M9gLBlJsmWaz/EJwASfeeWwLM1z8tjh0vOApz7L7lx
 cNQXdVnUFSaQ==
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="375870368"
Date: Sun, 7 Mar 2021 14:49:27 -0800
From: Andi Kleen <ak@linux.intel.com>
To: John Wood <john.wood@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 7/8] Documentation: Add documentation for the Brute LSM
Message-ID: <20210307224927.GT472138@tassilo.jf.intel.com>
References: <20210227153013.6747-1-john.wood@gmx.com>
 <20210227153013.6747-8-john.wood@gmx.com>
 <878s78dnrm.fsf@linux.intel.com>
 <20210302183032.GA3049@ubuntu>
 <20210307151920.GR472138@tassilo.jf.intel.com>
 <20210307164520.GA16296@ubuntu>
 <20210307172540.GS472138@tassilo.jf.intel.com>
 <20210307180541.GA17108@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307180541.GA17108@ubuntu>

On Sun, Mar 07, 2021 at 07:05:41PM +0100, John Wood wrote:
> On Sun, Mar 07, 2021 at 09:25:40AM -0800, Andi Kleen wrote:
> > > processes created from it will be killed. If the systemd restart the network
> > > daemon and it will crash again, then the systemd will be killed. I think this
> > > way the attack is fully mitigated.
> >
> > Wouldn't that panic the system? Killing init is usually a panic.
> 
> The mitigation acts only over the process that crashes (network daemon) and the
> process that exec() it (systemd). This mitigation don't go up in the processes
> tree until reach the init process.

Most daemons have some supervisor that respawns them when they crash. 
(maybe read up on "supervisor trees" if you haven't, it's a standard concept)

That's usually (but not) always init, as in systemd. There might be something
inbetween it and init, but likely init would respawn the something in between
it it. One of the main tasks of init is to respawn things under it.

If you have a supervisor tree starting from init the kill should eventually
travel up to init.

At least that's the theory. Do you have some experiments that show
this doesn't happen?

> 
> Note: I am a kernel newbie and I don't know if the systemd is init. Sorry if it
> is a stupid question. AFAIK systemd is not the init process (the first process
> that is executed) but I am not sure.

At least the part of systemd that respawns is often (but not always) init.

> 
> >
> > > > Or if it's a interactive login you log in again.
> > >
> > > First the login will be killed (if it fails with a fatal signal) and if it is
> > > restarted, the process that exec() it again will be killed. In this case I think
> > > that the threat is also completely mitigated.
> >
> > Okay so sshd will be killed. And if it gets restarted eventually init,
> > so panic again.
> 
> In this scenario the process that exec() the login will be killed (sshd
> process). But I think that sshd is not the init process. So no panic.

sshd would be respawned by the supervisor, which is likely init.

> > That's a fairly drastic consequence because even without panic
> > it means nobody can fix the system anymore without a console.
> 
> So, you suggest that the mitigation method for the brute force attack through
> the execve system call should be different (not kill the process that exec).
> Any suggestions would be welcome to improve this feature.

If the system is part of some cluster, then panicing on attack or failure
could be a reasonable reaction. Some other system in the cluster should
take over. There's also a risk that all the systems get taken
out quickly one by one, in this case you might still need something
like the below.

But it's something that would need to be very carefully considered
for the environment.

The other case is when there isn't some fallback, as in a standalone
machine.

It could be only used when the supervisor daemons are aware of it.
Often they already have respawn limits, but would need to make sure they
trigger before your algorithm trigger. Or maybe some way to opt-out 
per process.  Then the DoS would be only against that process, but
not everything on the machine. 

So I think it needs more work on the user space side for most usages.

-Andi
