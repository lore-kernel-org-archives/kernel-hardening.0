Return-Path: <SRS0=jfh1=QC=lists.openwall.com=kernel-hardening-return-21483-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A175C433F5
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Nov 2021 20:54:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4CE2A61AA9
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Nov 2021 20:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4CE2A61AA9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 30516 invoked by uid 550); 15 Nov 2021 20:53:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3355 invoked from network); 15 Nov 2021 15:52:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xfEQLsUP0WNGLcYW4jQPYqWVmCns3/58ZCB1K10eac=;
        b=FwMZYRIcrFcW4JIm/V+L8fQmT6+z60U50Ph/C4jzB3pgEq6pX3+eBThGykXJx33UOG
         rWTbIrgpXXThRpkjBFtBoDoTF2RyhJ5E8HBCMERsZj55lWhCEC/wl63Bpy4AE34S9T7c
         dUKg8J9ZNVbhoVqoeyr3kLsS2wSee/T7l1wq26uuOdIrhuPxjNwUFKnJ4bU9OgoVBhl9
         9zDdqaNfn1bxZgYwjZzA+0roJMK20X7/KGqK8ymNl673Gaq4C1f/pE9eTYFA5ntIGQH0
         9Gjbqj3Nzlgle37wxK1alJznNCth4S2jJvozvssBOd72LDrfk7lf+WAJFKQ3SQFnkpYR
         B1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xfEQLsUP0WNGLcYW4jQPYqWVmCns3/58ZCB1K10eac=;
        b=RoqMkkOH2oeApLOOOmHUcuLiBlZ5vb7U7DSa/ezCDo64aH64KjKZrZOw7jm3C4sHuD
         nFVbg5E5HBoJIi9jjhcybQcYh4byjIQwkSExrR41sxkbocrsgf2VUVFTBw0YM0n5DYbm
         9326pk+C2FYSLzoEGuaeq/5BXEkNwlzBmU28h7ERrcwV26o8Z4TB/wJihAE3G5FXWmp4
         fiamSdfOJiY5YbJiX0SMiJPjRsrlaA3tt68RpnmWq7Oz69cAhSMDpIye2RzRtsHAoiK7
         uvRJ9QMxa3711Qt725zKrcSjCDQ+Dbw0Blc/n4WP4Wunl2v7cYyWnfliMTUV13/fAXWH
         lfMg==
X-Gm-Message-State: AOAM533+6jBznZgngfCt6XczOFFsX/6Sak02PCEjzV0C3/v5G/tUKaZD
	I/CHmBTKAmcx2Gc3bo2psqDsZIsiaksTmYrxmb4=
X-Google-Smtp-Source: ABdhPJyGXyoue9vknBdR2p7ofgAMUu8YzEjmcwZi6GnesTvirdmcuocCISPigXHjImiUb8V+ZojMsIe2waK8kbTBeXA=
X-Received: by 2002:ac2:42c5:: with SMTP id n5mr36512837lfl.511.1636991560988;
 Mon, 15 Nov 2021 07:52:40 -0800 (PST)
MIME-Version: 1.0
References: <20211027233215.306111-1-alex.popov@linux.com> <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
 <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
 <77b79f0c-48f2-16dd-1d00-22f3a1b1f5a6@linux.com> <CAKXUXMx5Oi-dNVKB+8E-pdrz+ooELMZf=oT_oGXKFrNWejz=fg@mail.gmail.com>
In-Reply-To: <CAKXUXMx5Oi-dNVKB+8E-pdrz+ooELMZf=oT_oGXKFrNWejz=fg@mail.gmail.com>
From: Robert Krutsch <krutsch@gmail.com>
Date: Mon, 15 Nov 2021 16:52:29 +0100
Message-ID: <CA+apmd+AG66fU0pMstSG2BCXY6SoNsP=Wt0Ckp=-=uafddgKqA@mail.gmail.com>
Subject: Re: [ELISA Safety Architecture WG] [PATCH v2 0/2] Introduce the
 pkill_on_warn parameter
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Alexander Popov <alex.popov@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>, 
	Maciej Rozycki <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness <john.ogness@linutronix.de>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn <jannh@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Laura Abbott <labbott@kernel.org>, David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>, 
	Arnd Bergmann <arnd@arndb.de>, Andrew Scull <ascull@google.com>, Marc Zyngier <maz@kernel.org>, 
	Jessica Yu <jeyu@kernel.org>, Iurii Zaikin <yzaikin@google.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Wang Qing <wangqing@vivo.com>, 
	Mel Gorman <mgorman@suse.de>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, 
	Andrew Klychkov <andrew.a.klychkov@gmail.com>, 
	Mathieu Chouquet-Stringer <me@mathieu.digital>, Daniel Borkmann <daniel@iogearbox.net>, Stephen Kitt <steve@sk2.org>, 
	Stephen Boyd <sboyd@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Mike Rapoport <rppt@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, notify@kernel.org, main@lists.elisa.tech, 
	safety-architecture@lists.elisa.tech, devel@lists.elisa.tech, 
	Shuah Khan <shuah@kernel.org>
Content-Type: multipart/alternative; boundary="0000000000007e3b7d05d0d5cccf"

--0000000000007e3b7d05d0d5cccf
Content-Type: text/plain; charset="UTF-8"

We can always kill on warnings but if these warnings are very frequent
nobody is going to buy the implementation. If you have a statistic showing
how frequent these warnings arise (in some typical system) and can argue
that the impact is minimal it would be easier to accept.

As Lukas was saying, currently we do not rate availability so high but in
next years this could become a key ask.

Even in consumer HW today this kind of reset mindset is avoided (we have
RAS features in all architectures nowadays).

//Robert



On Mon, Nov 15, 2021 at 3:00 PM Lukas Bulwahn <lukas.bulwahn@gmail.com>
wrote:

> On Sat, Nov 13, 2021 at 7:14 PM Alexander Popov <alex.popov@linux.com>
> wrote:
> >
> > On 13.11.2021 00:26, Linus Torvalds wrote:
> > > On Fri, Nov 12, 2021 at 10:52 AM Alexander Popov <alex.popov@linux.com>
> wrote:
> > >>
> > >> Hello everyone!
> > >> Friendly ping for your feedback.
> > >
> > > I still haven't heard a compelling _reason_ for this all, and why
> > > anybody should ever use this or care?
> >
> > Ok, to sum up:
> >
> > Killing the process that hit a kernel warning complies with the Fail-Fast
> > principle [1]. pkill_on_warn sysctl allows the kernel to stop the
> process when
> > the **first signs** of wrong behavior are detected.
> >
> > By default, the Linux kernel ignores a warning and proceeds the
> execution from
> > the flawed state. That is opposite to the Fail-Fast principle.
> > A kernel warning may be followed by memory corruption or other negative
> effects,
> > like in CVE-2019-18683 exploit [2] or many other cases detected by the
> SyzScope
> > project [3]. pkill_on_warn would prevent the system from the errors
> going after
> > a warning in the process context.
> >
> > At the same time, pkill_on_warn does not kill the entire system like
> > panic_on_warn. That is the middle way of handling kernel warnings.
> > Linus, it's similar to your BUG_ON() policy [4]. The process hitting
> BUG_ON() is
> > killed, and the system proceeds to work. pkill_on_warn just brings a
> similar
> > policy to WARN_ON() handling.
> >
> > I believe that many Linux distros (which don't hit WARN_ON() here and
> there)
> > will enable pkill_on_warn because it's reasonable from the safety and
> security
> > points of view.
> >
> > And I'm sure that the ELISA project by the Linux Foundation (Enabling
> Linux In
> > Safety Applications [5]) would support the pkill_on_warn sysctl.
> > [Adding people from this project to CC]
> >
> > I hope that I managed to show the rationale.
> >
>
> Alex, officially and formally, I cannot talk for the ELISA project
> (Enabling Linux In Safety Applications) by the Linux Foundation and I
> do not think there is anyone that can confidently do so on such a
> detailed technical aspect that you are raising here, and as the
> various participants in the ELISA Project have not really agreed on
> such a technical aspect being one way or the other and I would not see
> that happening quickly. However, I have spent quite some years on the
> topic on "what is the right and important topics for using Linux in
> safety applications"; so here are my five cents:
>
> One of the general assumptions about safety applications and safety
> systems is that the malfunction of a function within a system is more
> critical, i.e., more likely to cause harm to people, directly or
> indirectly, than the unavailability of the system. So, before
> "something potentially unexpected happens"---which can have arbitrary
> effects and hence effects difficult to foresee and control---, it is
> better to just shutdown/silence the system, i.e., design a fail-safe
> or fail-silent system, as the effect of shutdown is pretty easily
> foreseeable during the overall system design and you could think about
> what the overall system does, when the kernel crashes the usual way.
>
> So, that brings us to what a user would expect from the kernel in a
> safety-critical system: Shutdown on any event that is unexpected.
>
> Here, I currently see panic_on_warn as the closest existing feature to
> indicate any event that is unexpected and to shutdown the system. That
> requires two things for the kernel development:
>
> 1. Allow a reasonably configured kernel to boot and run with
> panic_on_warn set. Warnings should only be raised when something is
> not configured as the developers expect it or the kernel is put into a
> state that generally is _unexpected_ and has been exposed little to
> the critical thought of the developer, to testing efforts and use in
> other systems in the wild. Warnings should not be used for something
> informative, which still allows the kernel to continue running in a
> proper way in a generally expected environment. Up to my knowledge,
> there are some kernels in production that run with panic_on_warn; so,
> IMHO, this requirement is generally accepted (we might of course
> discuss the one or other use of warn) and is not too much to ask for.
>
> 2. Really ensure that the system shuts down when it hits warn and
> panic. That requires that the execution path for warn() and panic() is
> not overly complicated (stuffed with various bells and whistles).
> Otherwise, warn() and panic() could fail in various complex ways and
> potentially keep the system running, although it should be shut down.
> Some people in the ELISA Project looked a bit into why they believe
> panic() shuts down a system but I have not seen a good system analysis
> and argument why any third person could be convinced that panic()
> works under all circumstances where it is invoked or that at least,
> the circumstances under which panic really works is properly
> documented. That is a central aspect for using Linux in a
> reasonably-designed safety-critical system. That is possibly also
> relevant for security, as you might see an attacker obtain information
> because it was possible to "block" the kernel shutting down after
> invoking panic() and hence, the attacker could obtain certain
> information that was only possible because 1. the system got into an
> inconsistent state, 2. it was detected by some check leading to warn()
> or panic(), and 3. the system's security engineers assumed that the
> system must have been shutting down at that point, as panic() was
> invoked, and hence, this would be disallowing a lot of further
> operations or some specific operations that the attacker would need to
> trigger in that inconsistent state to obtain information.
>
> To your feature, Alex, I do not see the need to have any refined
> handling of killing a specific process when the kernel warns; stopping
> the whole system is the better and more predictable thing to do. I
> would prefer if systems, which have those high-integrity requirements,
> e.g., in a highly secure---where stopping any unintended information
> flow matters more than availability---or in fail-silent environments
> in safety systems, can use panic_on_warn. That should address your
> concern above of handling certain CVEs as well.
>
> In summary, I am not supporting pkill_on_warn. I would support the
> other points I mentioned above, i.e., a good enforced policy for use
> of warn() and any investigation to understand the complexity of
> panic() and reducing its complexity if triggered by such an
> investigation.
>
> Of course, the listeners and participants in the ELISA Project are
> very, very diverse and still on a steep learning curve, i.e., what
> does the kernel do, how complex are certain aspects in the kernel, and
> what are reasonable system designs that are in reach for
> certification. So, there might be some stakeholders in the ELISA
> Project that consider availability of a Linux system safety-critical,
> i.e., if the system with a Linux kernel is not available, something
> really bad (harmful to people) happens. I personally do not know how
> these stakeholders could (ever) argue the availability of a complex
> system with a Linux kernel, with the availability criteria and the
> needed confidence (evidence and required methods) for exposing anyone
> to such system under our current societal expectations on technical
> systems (you would to need show sufficient investigation of the
> kernel's availability for a certification), but that does not stop
> anyone looking into it... Those stakeholders should really speak for
> themselves, if they see any need for such a refined control of
> "something unexpected happens" (an invocation of warn) and more
> generally what features from the kernel are needed for such systems.
>
>
> Lukas
>
>
> -=-=-=-=-=-=-=-=-=-=-=-
> Links: You receive all messages sent to this group.
> View/Reply Online (#629):
> https://lists.elisa.tech/g/safety-architecture/message/629
> Mute This Topic: https://lists.elisa.tech/mt/87069369/5378625
> Group Owner: safety-architecture+owner@lists.elisa.tech
> Unsubscribe: https://lists.elisa.tech/g/safety-architecture/unsub [
> krutsch@gmail.com]
> -=-=-=-=-=-=-=-=-=-=-=-
>
>
>

--0000000000007e3b7d05d0d5cccf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">We can always kill on warnings but if these warnings are v=
ery frequent nobody is going to buy the implementation. If you have a stati=
stic showing how frequent these warnings arise (in some typical system) and=
 can argue that the impact is minimal it would be easier to accept.<div><br=
></div><div>As Lukas was saying, currently we do not rate availability so h=
igh but in next years this could become a key ask.=C2=A0</div><div><br></di=
v><div>Even in consumer HW today this kind of reset mindset is avoided (we =
have RAS features in all architectures nowadays).=C2=A0</div><div><br></div=
><div>//Robert=C2=A0</div><div><br></div><div><br></div></div><br><div clas=
s=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Nov 15, 202=
1 at 3:00 PM Lukas Bulwahn &lt;<a href=3D"mailto:lukas.bulwahn@gmail.com">l=
ukas.bulwahn@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">On Sat, Nov 13, 2021 at 7:14 PM Alexander Popov &lt;<=
a href=3D"mailto:alex.popov@linux.com" target=3D"_blank">alex.popov@linux.c=
om</a>&gt; wrote:<br>
&gt;<br>
&gt; On 13.11.2021 00:26, Linus Torvalds wrote:<br>
&gt; &gt; On Fri, Nov 12, 2021 at 10:52 AM Alexander Popov &lt;<a href=3D"m=
ailto:alex.popov@linux.com" target=3D"_blank">alex.popov@linux.com</a>&gt; =
wrote:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Hello everyone!<br>
&gt; &gt;&gt; Friendly ping for your feedback.<br>
&gt; &gt;<br>
&gt; &gt; I still haven&#39;t heard a compelling _reason_ for this all, and=
 why<br>
&gt; &gt; anybody should ever use this or care?<br>
&gt;<br>
&gt; Ok, to sum up:<br>
&gt;<br>
&gt; Killing the process that hit a kernel warning complies with the Fail-F=
ast<br>
&gt; principle [1]. pkill_on_warn sysctl allows the kernel to stop the proc=
ess when<br>
&gt; the **first signs** of wrong behavior are detected.<br>
&gt;<br>
&gt; By default, the Linux kernel ignores a warning and proceeds the execut=
ion from<br>
&gt; the flawed state. That is opposite to the Fail-Fast principle.<br>
&gt; A kernel warning may be followed by memory corruption or other negativ=
e effects,<br>
&gt; like in CVE-2019-18683 exploit [2] or many other cases detected by the=
 SyzScope<br>
&gt; project [3]. pkill_on_warn would prevent the system from the errors go=
ing after<br>
&gt; a warning in the process context.<br>
&gt;<br>
&gt; At the same time, pkill_on_warn does not kill the entire system like<b=
r>
&gt; panic_on_warn. That is the middle way of handling kernel warnings.<br>
&gt; Linus, it&#39;s similar to your BUG_ON() policy [4]. The process hitti=
ng BUG_ON() is<br>
&gt; killed, and the system proceeds to work. pkill_on_warn just brings a s=
imilar<br>
&gt; policy to WARN_ON() handling.<br>
&gt;<br>
&gt; I believe that many Linux distros (which don&#39;t hit WARN_ON() here =
and there)<br>
&gt; will enable pkill_on_warn because it&#39;s reasonable from the safety =
and security<br>
&gt; points of view.<br>
&gt;<br>
&gt; And I&#39;m sure that the ELISA project by the Linux Foundation (Enabl=
ing Linux In<br>
&gt; Safety Applications [5]) would support the pkill_on_warn sysctl.<br>
&gt; [Adding people from this project to CC]<br>
&gt;<br>
&gt; I hope that I managed to show the rationale.<br>
&gt;<br>
<br>
Alex, officially and formally, I cannot talk for the ELISA project<br>
(Enabling Linux In Safety Applications) by the Linux Foundation and I<br>
do not think there is anyone that can confidently do so on such a<br>
detailed technical aspect that you are raising here, and as the<br>
various participants in the ELISA Project have not really agreed on<br>
such a technical aspect being one way or the other and I would not see<br>
that happening quickly. However, I have spent quite some years on the<br>
topic on &quot;what is the right and important topics for using Linux in<br=
>
safety applications&quot;; so here are my five cents:<br>
<br>
One of the general assumptions about safety applications and safety<br>
systems is that the malfunction of a function within a system is more<br>
critical, i.e., more likely to cause harm to people, directly or<br>
indirectly, than the unavailability of the system. So, before<br>
&quot;something potentially unexpected happens&quot;---which can have arbit=
rary<br>
effects and hence effects difficult to foresee and control---, it is<br>
better to just shutdown/silence the system, i.e., design a fail-safe<br>
or fail-silent system, as the effect of shutdown is pretty easily<br>
foreseeable during the overall system design and you could think about<br>
what the overall system does, when the kernel crashes the usual way.<br>
<br>
So, that brings us to what a user would expect from the kernel in a<br>
safety-critical system: Shutdown on any event that is unexpected.<br>
<br>
Here, I currently see panic_on_warn as the closest existing feature to<br>
indicate any event that is unexpected and to shutdown the system. That<br>
requires two things for the kernel development:<br>
<br>
1. Allow a reasonably configured kernel to boot and run with<br>
panic_on_warn set. Warnings should only be raised when something is<br>
not configured as the developers expect it or the kernel is put into a<br>
state that generally is _unexpected_ and has been exposed little to<br>
the critical thought of the developer, to testing efforts and use in<br>
other systems in the wild. Warnings should not be used for something<br>
informative, which still allows the kernel to continue running in a<br>
proper way in a generally expected environment. Up to my knowledge,<br>
there are some kernels in production that run with panic_on_warn; so,<br>
IMHO, this requirement is generally accepted (we might of course<br>
discuss the one or other use of warn) and is not too much to ask for.<br>
<br>
2. Really ensure that the system shuts down when it hits warn and<br>
panic. That requires that the execution path for warn() and panic() is<br>
not overly complicated (stuffed with various bells and whistles).<br>
Otherwise, warn() and panic() could fail in various complex ways and<br>
potentially keep the system running, although it should be shut down.<br>
Some people in the ELISA Project looked a bit into why they believe<br>
panic() shuts down a system but I have not seen a good system analysis<br>
and argument why any third person could be convinced that panic()<br>
works under all circumstances where it is invoked or that at least,<br>
the circumstances under which panic really works is properly<br>
documented. That is a central aspect for using Linux in a<br>
reasonably-designed safety-critical system. That is possibly also<br>
relevant for security, as you might see an attacker obtain information<br>
because it was possible to &quot;block&quot; the kernel shutting down after=
<br>
invoking panic() and hence, the attacker could obtain certain<br>
information that was only possible because 1. the system got into an<br>
inconsistent state, 2. it was detected by some check leading to warn()<br>
or panic(), and 3. the system&#39;s security engineers assumed that the<br>
system must have been shutting down at that point, as panic() was<br>
invoked, and hence, this would be disallowing a lot of further<br>
operations or some specific operations that the attacker would need to<br>
trigger in that inconsistent state to obtain information.<br>
<br>
To your feature, Alex, I do not see the need to have any refined<br>
handling of killing a specific process when the kernel warns; stopping<br>
the whole system is the better and more predictable thing to do. I<br>
would prefer if systems, which have those high-integrity requirements,<br>
e.g., in a highly secure---where stopping any unintended information<br>
flow matters more than availability---or in fail-silent environments<br>
in safety systems, can use panic_on_warn. That should address your<br>
concern above of handling certain CVEs as well.<br>
<br>
In summary, I am not supporting pkill_on_warn. I would support the<br>
other points I mentioned above, i.e., a good enforced policy for use<br>
of warn() and any investigation to understand the complexity of<br>
panic() and reducing its complexity if triggered by such an<br>
investigation.<br>
<br>
Of course, the listeners and participants in the ELISA Project are<br>
very, very diverse and still on a steep learning curve, i.e., what<br>
does the kernel do, how complex are certain aspects in the kernel, and<br>
what are reasonable system designs that are in reach for<br>
certification. So, there might be some stakeholders in the ELISA<br>
Project that consider availability of a Linux system safety-critical,<br>
i.e., if the system with a Linux kernel is not available, something<br>
really bad (harmful to people) happens. I personally do not know how<br>
these stakeholders could (ever) argue the availability of a complex<br>
system with a Linux kernel, with the availability criteria and the<br>
needed confidence (evidence and required methods) for exposing anyone<br>
to such system under our current societal expectations on technical<br>
systems (you would to need show sufficient investigation of the<br>
kernel&#39;s availability for a certification), but that does not stop<br>
anyone looking into it... Those stakeholders should really speak for<br>
themselves, if they see any need for such a refined control of<br>
&quot;something unexpected happens&quot; (an invocation of warn) and more<b=
r>
generally what features from the kernel are needed for such systems.<br>
<br>
<br>
Lukas<br>
<br>
<br>
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-<br>
Links: You receive all messages sent to this group.<br>
View/Reply Online (#629): <a href=3D"https://lists.elisa.tech/g/safety-arch=
itecture/message/629" rel=3D"noreferrer" target=3D"_blank">https://lists.el=
isa.tech/g/safety-architecture/message/629</a><br>
Mute This Topic: <a href=3D"https://lists.elisa.tech/mt/87069369/5378625" r=
el=3D"noreferrer" target=3D"_blank">https://lists.elisa.tech/mt/87069369/53=
78625</a><br>
Group Owner: safety-architecture+owner@lists.elisa.tech<br>
Unsubscribe: <a href=3D"https://lists.elisa.tech/g/safety-architecture/unsu=
b" rel=3D"noreferrer" target=3D"_blank">https://lists.elisa.tech/g/safety-a=
rchitecture/unsub</a> [<a href=3D"mailto:krutsch@gmail.com" target=3D"_blan=
k">krutsch@gmail.com</a>]<br>
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-<br>
<br>
<br>
</blockquote></div>

--0000000000007e3b7d05d0d5cccf--
