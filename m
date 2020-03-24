Return-Path: <SRS0=9z5J=5J=lists.openwall.com=kernel-hardening-return-18189-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B96DC2BAEE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:51:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9100A206F6
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SWI87RLR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9100A206F6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18189-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32621 invoked by uid 550); 24 Mar 2020 16:51:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32601 invoked from network); 24 Mar 2020 16:51:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N4GZ7+M1eRD8an5K8OELlYenKfDSxyisShOnVR18rRU=; b=SWI87RLREq1G8eS1Z3UkgbOL0p
	bNHNo+3m3jDy6NqaD6lgk6E9M55IYXv9cfhQ4U/m3TXNeU0F2KlTX53PnObUuMNeVlJ1gkH2u2N6R
	D5gvmeidJjwsqgsFdXisT18Q7t5TQ6VhFQ+3m90HRTger2cxdygkelqCgubtTt9c2XQU43UDatsqN
	hT8WBbB2aFRGRhmAq8BnWOkIGcld4281RMuTyMKV6/G+s23GqR12lnGg03FVfw+8bRTXRnLGqVMJw
	75U0QGdWL580574YY2M7/tE8Nr4hP6vt2L8s/nVucP+OSxxOC3HSp8eXiqjwLmRlNWv8r6tfkBn+f
	oXqZY5kw==;
Date: Tue, 24 Mar 2020 17:51:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with
 data_race()
Message-ID: <20200324165128.GS20696@hirez.programming.kicks-ass.net>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-4-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:25PM +0000, Will Deacon wrote:
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
>   */
>  static inline int list_empty(const struct list_head *head)
>  {
> -	return READ_ONCE(head->next) == head;
> +	return data_race(READ_ONCE(head->next) == head);
>  }

list_empty() isn't lockless safe, that's what we have
list_empty_careful() for.
