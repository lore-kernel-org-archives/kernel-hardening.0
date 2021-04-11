Return-Path: <SRS0=ePpM=JI=lists.openwall.com=kernel-hardening-return-21191-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19135C433ED
	for <kernel-hardening@archiver.kernel.org>; Sun, 11 Apr 2021 08:46:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 26AEC60C41
	for <kernel-hardening@archiver.kernel.org>; Sun, 11 Apr 2021 08:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26AEC60C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21191-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24000 invoked by uid 550); 11 Apr 2021 08:46:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23967 invoked from network); 11 Apr 2021 08:46:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1618130776;
	bh=1Vjjks+zQW7ZziNWekmeuRzGkREulQj8fD8WOwQIaW0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lqHoz7dNSwtpS0Y4W78q4wta7aqyZw002JsOCiD0DveF6D2Di33OetZ2LtWnJB3M7
	 oEZ8dTQSWo36JUrMANDJrsCaAQDCm4HFTdpwTQb6N2uvcnx6itVQJOkqseScPjI/Tj
	 9ywJobl19TS8mZG53/fHWobEAkIT12XGvtdMbn5w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sun, 11 Apr 2021 10:46:02 +0200
From: John Wood <john.wood@gmx.com>
To: Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
	Andi Kleen <ak@linux.intel.com>
Cc: John Wood <john.wood@gmx.com>, kernelnewbies@kernelnewbies.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
Message-ID: <20210411084602.GA3111@ubuntu>
References: <20210404094837.GA3263@ubuntu>
 <193167.1617570625@turing-police>
 <20210405073147.GA3053@ubuntu>
 <115437.1617753336@turing-police>
 <20210407175151.GA3301@ubuntu>
 <184666.1617827926@turing-police>
 <20210408015148.GB3762101@tassilo.jf.intel.com>
 <20210409142933.GA3150@ubuntu>
 <20210409150621.GJ3762101@tassilo.jf.intel.com>
 <109781.1618010900@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <109781.1618010900@turing-police>
X-Provags-ID: V03:K1:EAEmH3q/PIh5praZCAHmNWQtBjhZxAhZQELrlWn078K7j+7TAF3
 R9msrSb0bKzKAXgP1jmOtrwqnHIVNkIGmQVpo9kqBhnb8BFCBGqgUON+FjdNvqE/Md01qQx
 ihtitAxwKSufan3AGhQy30jdHjqCMj73Qyk4Iz8IRdgOfoKQwnambJAaC7IhhwU6nEwdwJ3
 +nZI/GhWGcO7wvusbYuEA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/mjAx4sG5S0=:Qq7JEAjjy+IbYLWb3HvGxb
 KW3TSJd+avTEVTklg6OuzIfJEGLTVKPuVDntr/Z/nhyQj/gXppFs9PftERV7emoUDxGFEuxHR
 IBdYK8I23fjK6qo8K88G0bRgK0TBlUKVcTyGPaqVnFkQ26pNE2f5fM5+YBuoibs0e4VfOAxo9
 6Ruc+bGQGye9zMn3Bz9LNmP79qst5pJtqmcMdYqk0Ls11P0e9oQhyXyMkGj+BoB2RKUbWhtvi
 6+HLGfeoSdJfhJmv6CRNH0qv9bSuKlxVC0ZIJ8F/DSYehA5HU7GCZZAq24KV0aYS494FEiEJi
 KVqmUytKh7aoyMjz0+0DzV9lbHQdZrjmqSHmQkl708iC72EhzZNPpyak5sNI2hMe+omfwlV7w
 6Cl+XweP0eeU8hzYPU2jW4ueIhvAe0jihzw1xHqDGjp0u8WLTv9RImt5CbSq7qt5571XeZCn1
 yYINTAURYa5dmVs9T61iRi3naCZV9brs1ZZFkeyd4sNDRVMjrc9UGqtP0l/70U3GNgGM0VnJ1
 TWYO5ncZCh3X5PGDGt3P0Z41if0cNQwYNVcGEwtMiw1cykoRsqxi6Mg0cLkzwtws5ukX5rjOB
 H1mwwzXZO1lj18isQ1Nr130rQTaB+BbXRz1jBZVJn00rFY9LKbA7ypYouOSXOUVe5au0gbAXp
 RpggfSmE46xKZ6bga0unZE1nKUALMwhKp5tyMCRpDeNOq31Q0h6vma9r8smJSOCm2pq3gKH65
 VasCgKNdBawwTAy8OVWMSwHAAayiX108RyjpKITySUgIntU5imICuJCsgHddqvThSi32fJbh7
 RTL8t2wyNos5DXEDNlpLTGhayqowOZhyQDUMqo4s4kjosn6XsWUDANnsxkyMC1i1PtUy2i+rF
 pIxFnM6mbNVtu/o/iXFAjODLjaIZSJEdSlBzudajBj0aqnZZwfvpO1pMQbhishl8eJRVfoylj
 tQV+mrAP6TgL94FxNvt9+q+WZUlVMIpQYKOsu8LBOCKmxHDjXXBxZeNiQ4JfTqHfjKKVybcDt
 098UxEJSoXChpia25qt37X3M/6hMlrRH4oy1p5c0kaE/wjIQSizEbLa/K5Nw8qKoeVeCaXodj
 1j2eNOF0TlyZY+MoP7XTsIhS/yRCCM60VYDajRXBV9CdU69NYsl++xTBBOarm61ZGmuUejGr6
 7rqdDINpcv7cuPVbx0W/gGXwKynkqeAKE9SMzyGFx6iVdl8b4OG8Jy7vBeEvyA3EHEa20=

Hi,

On Fri, Apr 09, 2021 at 07:28:20PM -0400, Valdis Kl=C4=93tnieks wrote:
> On Fri, 09 Apr 2021 08:06:21 -0700, Andi Kleen said:
>
> > Thinking more about it what I wrote above wasn't quite right. The cach=
e
> > would only need to be as big as the number of attackable services/suid
> > binaries. Presumably on many production systems that's rather small,
> > so a cache (which wouldn't actually be a cache, but a complete databas=
e)
> > might actually work.
>
> You also need to consider non-suid things called by suid things that don=
't
> sanitize input sufficiently before invocation...
>
> Thinking about at - is it really a good thing to try to do this in kerne=
lspace?
> Or is 'echo 1 > /proc/sys/kernel/print-fatal-signals' and a program to w=
atch
> the dmesg and take action more appropriate?  A userspace monitor would
> have more options (though a slightly higher risk of race conditions).
>

Thanks for the ideas. I need some time to send a formal proposal that
works properly. I would like to get feedback at that moment. I think it
would be better to discuss about the real patch.

Again, thanks.
John Wood
