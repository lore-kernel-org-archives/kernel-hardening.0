Return-Path: <SRS0=n0y4=U2=lists.openwall.com=kernel-hardening-return-16308-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98424C48BE4
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 20:00:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 05FF92075E
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 20:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05FF92075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16308-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20413 invoked by uid 550); 27 Jun 2019 20:00:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20370 invoked from network); 27 Jun 2019 20:00:34 -0000
Date: Fri, 28 Jun 2019 05:59:48 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: Alexander Potapenko <glider@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Hocko <mhocko@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
        Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
        Qian Cai <cai@lca.pw>, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v9 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
In-Reply-To: <20190627130316.254309-2-glider@google.com>
Message-ID: <alpine.LRH.2.21.1906280559270.18880@namei.org>
References: <20190627130316.254309-1-glider@google.com> <20190627130316.254309-2-glider@google.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 27 Jun 2019, Alexander Potapenko wrote:

> Signed-off-by: Alexander Potapenko <glider@google.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Christoph Lameter <cl@linux.com>
> To: Kees Cook <keescook@chromium.org>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Sandeep Patil <sspatil@android.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


Acked-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

