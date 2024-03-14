Return-Path: <kernel-hardening-return-21723-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1A4BCC54E5D
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Mar 2024 16:28:12 +0000 (UTC)
Received: (qmail 19471 invoked by uid 550); 14 Mar 2024 16:23:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18406 invoked from network); 14 Mar 2024 16:23:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710433671; x=1711038471; darn=lists.openwall.com;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCqqyqrVd1ZT9AtcPC9C9BzKjRf2o6CGP4oxyF2PKO0=;
        b=dpBLvXSgslJ5OJk1Vsw5qhFFh1ugn4Y9qXvzxQaFC/Gak4rwo09niaMr3/FuNtjyZA
         T9Yqyh5iBofJwE3KC7mmn6InVo/r+aQgT9KjOYKuS0qcJi+FJ5DSHZvsoqcQZzWWEf3r
         i4JTAXHQbqM5iRF+faIex1Ox8bIWoukHgSv2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710433671; x=1711038471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCqqyqrVd1ZT9AtcPC9C9BzKjRf2o6CGP4oxyF2PKO0=;
        b=DFLMRi1/C5jNewzbbYsOJUd2DvXy9BFtFbbfLh3f9nh5szHJqnXmBzidhCdWCa7m3a
         nCZoyJz5MwK7ykWUxN64im+jWj80RredB2FKeFQgPBiSk/n0LbBJL1oGgPo1qhGS1DsJ
         45RARcENbHSDlz6g7rju1B1xRqgvXEme1PBG/C198BfCqfG2j8rlq4WJnsI87QPKnqI4
         HMa1QJa6R5i8uEMyRAdGRNKnU3i9x4FP5JyhvB3QCTiJvvc4LSV73MIE/LP7u9aEb4/p
         bZWCKFWn5+Dq2rdT8IQ4/OYoIWOq32Vt/09/Nh1qdxUzoTO8M+JYdPFGZYerMqO33Lwt
         iKKQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3S5xXyDlXs9PEqgVqa/G791kd86rH1wvETC76mosuLHAqaCck1mS1zNcwhkkbWuclCCv2xiDT+sVOhu85khtT/OYq4bX098jZI7wS7qMoudUK/Q==
X-Gm-Message-State: AOJu0YylpyZfG2NDLlD7MlIzdtnm65aCr4q8NytlWSiFWoMPV0Qkdc3t
	goh5vREUvPLFhOlftopVQviiTPFW+SDLLnPGI6qRn8KgATwSOB77kDm1j36QKQ==
X-Google-Smtp-Source: AGHT+IGB+4KsUsZtAt2GEhKCBD82Z12NV2ggL3N9c8FAaT23sfhQfhvx2qsrcS+ssYSXM7KAVvrcSw==
X-Received: by 2002:a17:902:ba8c:b0:1dd:916d:771f with SMTP id k12-20020a170902ba8c00b001dd916d771fmr1835572pls.39.1710433671438;
        Thu, 14 Mar 2024 09:27:51 -0700 (PDT)
Date: Thu, 14 Mar 2024 09:27:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	x86@kernel.org, akpm@linux-foundation.org, shakeelb@google.com,
	vbabka@suse.cz, rppt@kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
	ardb@google.com
Subject: Re: [RFC PATCH v2 00/19] PKS write protected page tables
Message-ID: <202403140927.5A5F290@keescook>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

On Mon, Aug 30, 2021 at 04:59:08PM -0700, Rick Edgecombe wrote:
> This is a second RFC for the PKS write protected tables concept. I'm sharing to
> show the progress to interested people. I'd also appreciate any comments,
> especially on the direct map page table protection solution (patch 17).

*thread necromancy*

Hi,

Where does this series stand? I don't think it ever got merged?

-Kees

-- 
Kees Cook
