Return-Path: <SRS0=/g9Y=AW=lists.openwall.com=kernel-hardening-return-19287-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8063C433E1
	for <kernel-hardening@archiver.kernel.org>; Sat, 11 Jul 2020 17:43:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1B20F206F4
	for <kernel-hardening@archiver.kernel.org>; Sat, 11 Jul 2020 17:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="QPNpg729"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B20F206F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19287-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13628 invoked by uid 550); 11 Jul 2020 17:43:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13596 invoked from network); 11 Jul 2020 17:43:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1594489373;
	bh=EBgucKfeyAFfRSnbEwfpERwcbr6gmKybaMoinREcmP4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
	b=QPNpg729K8Uh227m9b5+oxQqf0TOTdOwbimFO8UI+tHmIeXU+X2FVOMNROpC7g5FZ
	 dK+JXWSD8z6mupSmwELzgAuBXPNvAKVqf9YSj+yXuGUKzn4Oh8lpN/+rGOfXX0PMYB
	 jjbRzWd8TTEeHzVSoGEwAQulrpYNqJVVO/PozvkQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 11 Jul 2020 19:42:40 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com,
	Oscar Carter <oscar.carter@gmx.com>
Subject: Clarification about the series to modernize the tasklet api
Message-ID: <20200711174239.GA3199@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:lB2l8rk9IMxjG3aVcYKZ3oKPWc0gxSlhj2gdOSG/yk5r2BFiaqb
 0wJ4k3lnKtr5CmTzBaiXKg4N4k+xapeYv/GCUPnjI7ojyK+uSvrbr07az0FzSi9uTXY6k6e
 OH0mOA/8pBYixBXQxGIiV2JgatJLttdxRpH0s4EIqwZ7+zKfYox3W4c5KhLVLXratgMmsu9
 juSzxDW2kgpyFs29eYLwQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8gghzFMI5Ds=:Es4/VTzmAGY4d7jJdT9nn3
 dTm/M5H+dvsaZEdEuOnrsZ0RUN/b2k2RQZIkkWC9KOjo1nrbTQmkWb4ax3EUNv8gQGWC7YlTx
 F8zFt+X2n1Mnz1LA7cZZk2m20ZqPDtup8igNylLPKgyzOygFQoe7wBbb3POreekLNal8blqFd
 phE08+RXHXBPrDDW/JqmGQsXY3G357zbrdcGNOHG4GZPzRjk8mN3XiOnWObE8cxdlm7rruP26
 R/btCaNuOQX80z3ccMoX7OoVymTBc2Efwd7n64Sxi9VDL34kzYh/nbmMcYoXpvPEh8wZaFpCV
 0+pe8+5tMM0EvYbGNpBkH9uz4vM/QgVaSolyhWX/3CGBQHi8Tx+AgWqOm6EhL+pMA0b053fHW
 Sn1CXbGaDvyqVAv5myR499fjRWklM8bb/LG1tLJZXszyCp0z2DgoLYPCOMY5bBjNQPsaVByAv
 NUGzqcb89CAPnqvgNvMX5mwC7QaTWCKWU72Liq5Yi2XPtYAjXIhqn8AztSj+e8gteUqAbhPA7
 E6yw/tawFUezoVrA7w8ysUdUs6kxlOAhnurbkTf4Pr40q2oMzDofE3DxNoEBTyUC2WhpDtUeC
 Hq+rpRrpBxqVGpbzuaEYn6jI8jXiRdWN1ueD6D+HGKncekt+vvoT0VNbdGHMTKBbUKk8aRQOE
 spKViOhVmYtlEczSgWE6RhPmXlww5F1Kh3aThvCxF3BTyzu5IRKSC5uO0DMSJS1Gm870zwdSD
 0huvAKrzlpI0hdsLz2SHHDYkwP06RP+jPMxHrnw8v0Pfm9D/6H7bnEhiNBvFQJKMqyKA+dGRk
 ZSKqG0LfYeVdta1chIEV+HMHi1iD4NYEXs9ILQW8i7l2Nunjp0u7j9YsdTNFho+m17NC5XbrE
 AZ3S8sTZZ0uZ0bQvihNpKL/tgEXTio824o2rF9C+/x2rEe5borwsgJJ0LCsqtLD6773BvQxO2
 WznySwFAzV7Mi7u86oz0o0SbC0x0U1u1K3MZMO7Ao0AarNLoXNo72ohDH+gLDBYAsdQmvZWv9
 ISkPQd/I6tx7Hq1qyashgP/O2ruRU6qo/apibB5Z+1JaROMKktWIc7YFz1AbxKQGPMPLa9dj1
 A5OjlWT0nf6DoAIDW2BsJp38JzyI/96aiMluO/60HSx0Gc7JJ51xnu/15Q1yxsStKyAos+XvU
 JByyoYyAwZZktbUHKsAPvFChz2UkazDRdl/lO2EqZnyxsqFKNdzmCBHlDi1mSLUHKPDIGRsq1
 BAU0NO2MY8Q2JIONFjhQxEhROlNE9VMVUomYQ3w==

Hi Kees,

I'm working to modernize the tasklet api but I don't understand the reply
to the patch 12/16 [1] of the patch series of Romain Perier [2].

If this patch is combined with the first one, and the function prototypes
are not changed accordingly and these functions don't use the from_tasklet()
helper, all the users that use the DECLARE_TASKLET macro don't pass the
correct argument to the .data field.

 #define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }

The data argument is lost.

If this patch is splitted in two, the first part will build correctly since
there are casts protecting the arguments, but it will not run correctly until
we apply the second part.

Is it correct? Or am I wrong?

The only imperative to apply a patch in a series is that it compiles correctly?
And I suppose that the next ones fix this situation.

At this moment I'm very confused. A bit of light about this will help me a lot.
And sorry if this is a trivial question.

[1] https://lore.kernel.org/kernel-hardening/201909301538.CEA6C827@keescook/
[2] https://lore.kernel.org/kernel-hardening/20190929163028.9665-1-romain.perier@gmail.com/

Thanks in advance,
Oscar Carter
