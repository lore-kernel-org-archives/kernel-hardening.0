Return-Path: <SRS0=5QGI=BR=lists.openwall.com=kernel-hardening-return-19573-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECA0C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 Aug 2020 17:21:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 12926221E5
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 Aug 2020 17:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GhIm2Pa7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12926221E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19573-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1650 invoked by uid 550); 7 Aug 2020 17:21:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1630 invoked from network); 7 Aug 2020 17:21:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZmKP+qCzihWJK9dXcNadQFATorS0FHUmvkMi7b8YfMY=;
        b=GhIm2Pa7v4YxhlXrHy3f/nlqbB1X4jZ2cO8Etlvz9zwHwM00RutEXb0eh+mr4sOATP
         aLxjs3msffA79SRugYCIpDPFF4XCrcdo2yPLvYsSi1VzP0prKlxDewDF4VO7M7mgBqrQ
         wBjOViIeaHA0LQo495hDAQ1HNFKtu0yZuJAlw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZmKP+qCzihWJK9dXcNadQFATorS0FHUmvkMi7b8YfMY=;
        b=oiv3T6DhQond/BuFg9pPb3tPqgIVnHNXfArQomNejVLHfRvbs+tDlh5HqTyfIc/RhV
         jo49ajAJBzlgD9/eDS9RDFLfyh5WsoySdqDbO/rEO6H8UlBPki/UOviIJSbiBS1vUxdb
         SkOY4qA1bjx81HFA/0KNYY6T94HcmqO1FxcOKo0DSQkQmyuXIBEKI4beF6KVU3YzNn35
         88eoTjY+hSW79Te16Wh6bXZO67MBVRlL6M+/U1f5x9j5HaNfpmNwF0RNSL0CkUPZcqu5
         py4CoLlBprWjY2lz2+cNWyIzC43ADOLjiO266hf5ZBDKUVJgZTS7QsDue7JX3OVQ3psu
         zJ7w==
X-Gm-Message-State: AOAM532iRRYsjCUz0BA7dygPREs/sapo6ktYMjMq2K9bozyd+OjlbRFT
	SMS4+GQTco61qdwLQf5QGcDeJg==
X-Google-Smtp-Source: ABdhPJyB6OwUfUimb8Uz2hhZTkIwGjClz3vVRtHwCFeTj6wgxCBADhupXVxYQDrplWNO0sPKqpn5Ug==
X-Received: by 2002:a17:902:8643:: with SMTP id y3mr13409666plt.199.1596820855376;
        Fri, 07 Aug 2020 10:20:55 -0700 (PDT)
Date: Fri, 7 Aug 2020 10:20:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <202008071019.BF206AE8BD@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <20200804182359.GA23533@redhat.com>
 <f8963aab93243bc046791dba6af5d006e15c91ff.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8963aab93243bc046791dba6af5d006e15c91ff.camel@linux.intel.com>

On Fri, Aug 07, 2020 at 09:38:11AM -0700, Kristen Carlson Accardi wrote:
> Thanks for testing. Yes, Josh and I have been discussing the orc_unwind
> issues. I've root caused one issue already, in that objtool places an
> orc_unwind_ip address just outside the section, so my algorithm fails
> to relocate this address. There are other issues as well that I still
> haven't root caused. I'll be addressing this in v5 and plan to have
> something that passes livepatch testing with that version.

FWIW, I'm okay with seeing fgkaslr be developed progressively. Getting
it working with !livepatching would be fine as a first step. There's
value in getting the general behavior landed, and then continuing to
improve it.

-- 
Kees Cook
