Return-Path: <SRS0=LslW=IO=lists.openwall.com=kernel-hardening-return-20956-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC04C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:33:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ECDA864E07
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:33:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECDA864E07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20956-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3588 invoked by uid 550); 16 Mar 2021 19:33:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3564 invoked from network); 16 Mar 2021 19:33:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m51X9CHwtfCE5IH0P5AqXawZY6zUnwHs3ugCFSUHYWY=;
        b=O7izbeJETQwKGKZ937uPGZzffYmkBls3HZoWUKMlGCiundJ7Esi6XAj8SgsJvWW0bv
         EJUFAG+4vJqYaQUGivkM98LHXg2BKzD8QVMa4YwQpHq1qpaDrWp8lpCb3ag0Q4QiV/vF
         6tH4HcqcvVGLbNhOh8UgqfrH9b3TNRcSjeCPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m51X9CHwtfCE5IH0P5AqXawZY6zUnwHs3ugCFSUHYWY=;
        b=P1MVa2sH8HrQnMdlTPEd+OhE2hYM3g7oQh6tVw7RT1kCmwK0YYsveR9yMeG0/08rPj
         mjp2ppSOMkaPPBarrH7mHDNnsq4iCmLxnsqCIIvLYvBI9eApJLyCHhZciAVWBNwjhN05
         Mxs4jN676VJJ3x6BC8a8yysG8hvK4L8WsA+Sy0pXxDyqIIN+vUk8O0OTALY4w+aW5cAT
         Mpa3OXFPmyolER0tUw7wV155nbgMCB+EJU/44xnF33E5opJMm+O9vcRBTI+fPkx0sWp5
         UiA2YlffvwZjeDyvo3q8C1hTcS3578Vxc5GzUAgTVaT9Vw1NHchEp7B6RuIoLWcIaN0k
         gj8w==
X-Gm-Message-State: AOAM5339K/wIBLKBh28d6DZ/PNCf1zqfHFSTntBN1B33vpBOwBaRUXMq
	noH7zFGlMOC9/4R3uHErj1o6vg==
X-Google-Smtp-Source: ABdhPJymLmZUQcJf9mTPzHM6y4qPylvnlWR8uKp+iBIhoMb95+cXNuw7H/BK680P/1W8mJYXiVs6sg==
X-Received: by 2002:a17:902:c1d5:b029:e6:52e0:6bdd with SMTP id c21-20020a170902c1d5b02900e652e06bddmr902471plc.49.1615923179208;
        Tue, 16 Mar 2021 12:32:59 -0700 (PDT)
Date: Tue, 16 Mar 2021 12:32:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	io-uring <io-uring@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>, Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
Message-ID: <202103161229.75FDE42F@keescook>
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
 <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
 <202103151426.ED27141@keescook>
 <CAHk-=wjYOCgM+mKzwTZwkDDg12DdYjFFkmoFKYLim7NFmR9HBg@mail.gmail.com>
 <202103161146.E118DE5@keescook>
 <CAHk-=wj7k2nCB8Q5kMYsYi1ajb99yZ-EYn_MYFMQ2bw3nWuT5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj7k2nCB8Q5kMYsYi1ajb99yZ-EYn_MYFMQ2bw3nWuT5Q@mail.gmail.com>

On Tue, Mar 16, 2021 at 12:26:05PM -0700, Linus Torvalds wrote:
> Note that the above very intentionally does allow the "we can go over
> the limit" case for another reason: we still have that regular
> *unconditional* get_page(), that has a "I absolutely need a temporary
> ref to this page, but I know it's not some long-term thing that a user
> can force". That's not only our traditional model, but it's something
> that some kernel code simply does need, so it's a good feature in
> itself. That might be less of an issue for ucounts, but for pages, we
> somethines do have "I need to take a ref to this page just for my own
> use while I then drop the page lock and do something else".

Right, get_page() has a whole other set of requirements. :) I just
couldn't find the "we _must_ to get a reference to ucounts" code path,
so I was scratching my head.

> And it's possible that "refcount_t" could use that exact same model,
> and actually then offer that option that ucounts wants, of a "try to
> get a refcount, but if we have too many refcounts, then never mind, I
> can just return an error to user space instead".

Yeah, if there starts to be more of these cases, I think it'd be a
nice addition. And with the recent performance work Will Deacon did on
refcount_t, I think any general performance concerns are met now. But
I'd love to just leave refcount_t alone until we can really show a need
for an API change. :P

-- 
Kees Cook
