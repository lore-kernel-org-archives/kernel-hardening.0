Return-Path: <kernel-hardening-return-21594-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 4AA81C4332F
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Dec 2022 20:14:14 +0000 (UTC)
Received: (qmail 9344 invoked by uid 550); 2 Dec 2022 20:14:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9309 invoked from network); 2 Dec 2022 20:14:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rNEZlNoSAlfJef2s1RQdVmz4/bQBOUK5DuhGxPB7vAk=;
        b=Kcqfmgn+lpfNsKb9spea06UlV2GZhmwN/OS0ktDSzoo4CmrAdoRMRBIvUIb2aluXos
         QInSZOJOqzcEdcgwinOc4F1tqgA2R9yQnZBYcyOk5x+lypWug/4bP88rY6K1ssJNO48r
         ZSeBNKeWf1jpWfPZ3KjPge8KY9ioTstixhupU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNEZlNoSAlfJef2s1RQdVmz4/bQBOUK5DuhGxPB7vAk=;
        b=6TC0nuhgXWJUydv6XnXlE7nRiGSqgZ0iJKWKVJ5aDm+vZeNVBDBAYLwsmj/o0U7wR7
         DBztp9eFbhTdAwJAbKjlZ26iUVFQXlbTVTzU10oIcdvf3LOOmHVO3Ovnu+9iYiy0gmKv
         HbzWglpu2+qETbJgi/41ApHY15QbBQjY9wfmgmoPyUNmxZv9rb5AO299Rj3ZJNXgTovT
         x2dxhmGLpkMYgdJ5kV9K/UKCRLG2Udp5+ddb+h4hjVJT7foB29pZ5XlpW5C2lj2acQnu
         k+2aY8caLsyoqd5oWv5VxxYN7u4pe7XbrIYOdzJyuW6z22Piy6fUuYzJVA6cQLu06qpJ
         b6VA==
X-Gm-Message-State: ANoB5pkPtoVJKGs+6w1UUDM99BpXctQrqWxreyyxALSQJ7D8Z3p5gmn+
	eMlkvnqnaRkScB71f3gF9P0vp8X4pKFH7jqh
X-Google-Smtp-Source: AA0mqf76st5RS08ATVWFRrBuDwh2jDmMNVtVwNTlAusXAtO3pbdPexLKLCdZJby2GO03QFbCi4R4Ig==
X-Received: by 2002:a63:2226:0:b0:478:54e2:ecb1 with SMTP id i38-20020a632226000000b0047854e2ecb1mr14859655pgi.550.1670012029999;
        Fri, 02 Dec 2022 12:13:49 -0800 (PST)
Date: Fri, 2 Dec 2022 12:13:48 -0800
From: Kees Cook <keescook@chromium.org>
To: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Reducing runtime complexity
Message-ID: <202212021208.04CE21D1AE@keescook>
References: <Y4kJ4Hw0DVfy7S37@mailbox.org>
 <202212011520.F7FE481@keescook>
 <Y4mbqmsMjTA63SlP@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4mbqmsMjTA63SlP@mailbox.org>

On Fri, Dec 02, 2022 at 07:31:06AM +0100, Stefan Bavendiek wrote:
> On Thu, Dec 01, 2022 at 03:21:37PM -0800, Kees Cook wrote:
> > On Thu, Dec 01, 2022 at 09:09:04PM +0100, Stefan Bavendiek wrote:
> > > Some time ago I wrote a thesis about complexity in the Linux kernel and how to reduce it in order to limit the attack surface[1].
> > > While the results are unlikely to bring news to the audience here, it did indicate some possible ways to avoid exposing optional kernel features when they are not needed.
> > > The basic idea would be to either build or configure parts of the kernel after or during the installation on a specific host.
> > > 
> > > Distributions are commonly shipping the kernel as one large binary that includes support for nearly every hardware driver and optional feature, but the end user will normally use very little of this.
> > > In comparison, a custom kernel build for a particular device and use case, would be significantly smaller. While the reduced complexity won't be directly linked with reduction in attack surface, from my understanding the difference would make a relevant impact.
> > > 
> > > The question I keep wondering about is how feasible this is for general purpose distributions to have the kernel "rebuild" in this way when it is installed on a particular machine.
> > 
> > Much of the functionality is modules, so once a system is booted and
> > running the expected workloads, one can set the modules_disabled sysctl
> > and block everything else from being loaded.
> > 
> > -Kees
> > 
> > -- 
> > Kees Cook
> 
> Disableing modules in general will prevent quite a lot of functionality that would still be expected to work, like plugging in a usb device.
> One approach may be to load everything that may possibly be required in the future as well based on the use case of the specific system and then disable loading additional modules, but that does not seem like a good solution either.
> 
> Perhaps exploring embedded device deployments is an idea, but in general the idea is to ship a smaller kernel to something like Linux desktops without limiting functionality that likely to be required.

What I mean is that we already have a good middle-ground. It doesn't
need to be all (general distro) or nothing (embedded build). Once the
workload for the system is known, load the needed modules and block
everything else. i.e. set up a module alias named "disable", and then
fill /etc/modules with whatever you might want that isn't automatically
loaded at boot and end the list with "disable". I wrote this up almost
exactly 10 years ago:

https://outflux.net/blog/archives/2012/11/28/clean-module-disabling/

:)

-Kees

-- 
Kees Cook
