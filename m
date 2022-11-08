Return-Path: <kernel-hardening-return-21584-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 5798FC43217
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Nov 2022 17:25:03 +0000 (UTC)
Received: (qmail 22208 invoked by uid 550); 8 Nov 2022 17:24:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22175 invoked from network); 8 Nov 2022 17:24:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2jXnwrdOctEAg+6kVY9hCNzqeQ8ppwfCq8v7ax8XLyc=;
        b=h6D/IhT6OiuD6Oz+6iB4e635Qux6H+f6qBbBPVTGtHvODhDFB2CnQs8vlNB+Nsbafg
         03RtBAuw9ByoFQs980ux+z2LmzPfeAtYXLRCq6JM5hxHViWryYtF8bTcTb7X1FEzY/K6
         UORYYY6hBNReHXNzkYb6gfgK1E2XkcDT9Na40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jXnwrdOctEAg+6kVY9hCNzqeQ8ppwfCq8v7ax8XLyc=;
        b=GW3aFiQIVAVSCyccVl5MrlwAIKW7xW3nMxs2DzzBSnQ/LDA0iDPFJ9dtVXlZhjgWkT
         VZ5IZ5CWbfaPqha8ZYbr+bZkt/o2zq4Np3kd/PhXhnr7LKGC0DOLh1L01cY48tOnbPpj
         IdVuRADC+ZgfkOwWfEgJ5OP5uBWHX3gVUj0yKf680uOkhmBK4Sv6+oWlXOk5LlxNH1nY
         iUtbeBM/GVxu+LHFwDDLqfwqp1ldxp+oR/cD8JGjNdfIuod5wzW3FcC0f7WKLU6PTw9l
         IO9IJhAvGazla5eygSfJBzZBqf/8gkTG/2mEs1+VnWALb/f8aZr/RnqnX2p61S1kf5pP
         fpwg==
X-Gm-Message-State: ACrzQf1M/QVNCgtAATQ97EG1Y5s6+0VkW+1Kv6amg96fwuluavmQagVH
	Zzv/P2KNb4aojq42OFyvRM7XyA==
X-Google-Smtp-Source: AMsMyM7BM+yOcGq3Phx6Hb1U5oS2KniFsbemmzg1XGdqd6aw4Uxv40mr3JOyoKudrTJspDw0hxUsMA==
X-Received: by 2002:a17:90a:d24d:b0:213:d3e4:677a with SMTP id o13-20020a17090ad24d00b00213d3e4677amr49640405pjw.101.1667928281513;
        Tue, 08 Nov 2022 09:24:41 -0800 (PST)
Date: Tue, 8 Nov 2022 09:24:40 -0800
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Solar Designer <solar@openwall.com>, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Seth Jenkins <sethjenkins@google.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
Message-ID: <202211080923.8BAEA9980@keescook>
References: <20221107201317.324457-1-jannh@google.com>
 <20221107211440.GA4233@openwall.com>
 <CAG48ez2-xUawSs4ji_+0Bnyn_QTiS930UiOypXreU_RhwhVo_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2-xUawSs4ji_+0Bnyn_QTiS930UiOypXreU_RhwhVo_w@mail.gmail.com>

On Mon, Nov 07, 2022 at 10:48:20PM +0100, Jann Horn wrote:
> On Mon, Nov 7, 2022 at 10:15 PM Solar Designer <solar@openwall.com> wrote:
> > On Mon, Nov 07, 2022 at 09:13:17PM +0100, Jann Horn wrote:
> > > +oops_limit
> > > +==========
> > > +
> > > +Number of kernel oopses after which the kernel should panic when
> > > +``panic_on_oops`` is not set.
> >
> > Rather than introduce this separate oops_limit, how about making
> > panic_on_oops (and maybe all panic_on_*) take the limit value(s) instead
> > of being Boolean?  I think this would preserve the current behavior at
> > panic_on_oops = 0 and panic_on_oops = 1, but would introduce your
> > desired behavior at panic_on_oops = 10000.  We can make 10000 the new
> > default.  If a distro overrides panic_on_oops, it probably sets it to 1
> > like RHEL does.
> >
> > Are there distros explicitly setting panic_on_oops to 0?  If so, that
> > could be a reason to introduce the separate oops_limit.
> >
> > I'm not advocating one way or the other - I just felt this should be
> > explicitly mentioned and decided on.
> 
> I think at least internally in the kernel, it probably works better to
> keep those two concepts separate? For example, sparc has a function
> die_nmi() that uses panic_on_oops to determine whether the system
> should panic when a watchdog detects a lockup.

Internally, yes, the kernel should keep "panic_on_oops" to mean "panic
_NOW_ on oops?" but I would agree with Solar -- this is a counter as far
as userspace is concerned. "Panic on Oops" after 1 oops, 2, oopses, etc.
I would like to see this for panic_on_warn too, actually.

-- 
Kees Cook
