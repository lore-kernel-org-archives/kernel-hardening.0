Return-Path: <SRS0=7+LH=IR=lists.openwall.com=kernel-hardening-return-21003-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67438C433DB
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:15:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6D4716194D
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D4716194D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21003-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11671 invoked by uid 550); 19 Mar 2021 19:15:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11651 invoked from network); 19 Mar 2021 19:15:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UhVshRutOq0lszJbq/YX4dDlC5l4aOjl7AUjxQMu52w=;
        b=bBKx+9uN8xnCc5sshFh2/XhWXlYamoIzo+jRJ+PEm23+wwPHDN30u21VYQIXFuEQpD
         w+w4KIEC/rk6vS+80NpNCv+5zSBGLevW+p8ahQVPa2S2k9ZqiIfInhQI3nIlyFhnIbyL
         FS7xcu7RdHUC6pgg3s5aV9vLgE7MofLySVDYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UhVshRutOq0lszJbq/YX4dDlC5l4aOjl7AUjxQMu52w=;
        b=Lxwil5ohrrQkX+xSUmdnRDSedVakoHYQOu367zsL4Vco9/rrk7rJglcQiNVxdDQnis
         qZ8TJOFx2Zjo8YBHPTTwDNWryTRozX/6zG5PETUtdgmuIgRiTkixz/We2p+125aKPX9g
         5tMFbkOSaw8AtZmxkrNdfj3IwffXC87blbYmQvfvNtrJOgolKesn+bmBAfUrAt+78Ddd
         vnhTuPbboWNPqheteQP8v0blSlIL8Y2pwbys8Q3YenRhepSxuGELCm+q11qgtlZwgl70
         ir91amS46kTANDSwu00IxiSWSQtlBm5U7VUGl4gz4n2ATzsv3+0mWcgJs/0VHotu+iM9
         8tZg==
X-Gm-Message-State: AOAM531ijorzlwTBPr6B/IdcE0VbvZ8BXcYE9RMva/aU+TRwp1EZnTPp
	lIxd1fQvgBW/TGo+C6OtY/KraA==
X-Google-Smtp-Source: ABdhPJyocwGZ+YCdp+AEKehahWsjJ+Q+SCbixvse5NoSiTvSwxOgE6bO6/4QIhmDO4axWxnOK6O7hQ==
X-Received: by 2002:a63:4761:: with SMTP id w33mr12829462pgk.118.1616181337860;
        Fri, 19 Mar 2021 12:15:37 -0700 (PDT)
Date: Fri, 19 Mar 2021 12:15:36 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 02/12] landlock: Add ruleset and domain management
Message-ID: <202103191213.D6B1B27423@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-3-mic@digikod.net>
 <202103191114.C87C5E2B69@keescook>
 <acda4be1-4076-a31d-fcfd-27764dd598c8@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acda4be1-4076-a31d-fcfd-27764dd598c8@digikod.net>

On Fri, Mar 19, 2021 at 08:03:22PM +0100, Mickaël Salaün wrote:
> On 19/03/2021 19:40, Kees Cook wrote:
> > On Tue, Mar 16, 2021 at 09:42:42PM +0100, Mickaël Salaün wrote:
> >> [...]
> >> +static void put_rule(struct landlock_rule *const rule)
> >> +{
> >> +	might_sleep();
> >> +	if (!rule)
> >> +		return;
> >> +	landlock_put_object(rule->object);
> >> +	kfree(rule);
> >> +}
> > 
> > I'd expect this to be named "release" rather than "put" since it doesn't
> > do any lifetime reference counting.
> 
> It does decrement rule->object->usage .

Well, landlock_put_object() decrements rule->object's lifetime. It seems
"rule" doesn't have a lifetime. (There is no refcounter on rule.) I just
find it strange to see "put" without a matching "get". Not a big deal.

-- 
Kees Cook
