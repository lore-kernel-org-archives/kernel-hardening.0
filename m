Return-Path: <kernel-hardening-return-21670-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A9272C77B75
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 May 2023 21:43:42 +0000 (UTC)
Received: (qmail 8172 invoked by uid 550); 15 May 2023 21:43:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8144 invoked from network); 15 May 2023 21:43:30 -0000
Date: Mon, 15 May 2023 16:43:12 -0500
From: Serge Hallyn <serge@hallyn.com>
To: David Hildenbrand <david@redhat.com>
Cc: Michael McCracken <michael.mccracken@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	tycho@tycho.pizza, Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
Message-ID: <ZGKncJpVPhOiA7XG@jerom>
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
 <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com>

On Fri, May 05, 2023 at 09:35:59AM +0200, David Hildenbrand wrote:
> On 04.05.23 23:30, Michael McCracken wrote:
> > Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_space
> > sysctl to 0444 to disallow all runtime changes. This will prevent
> > accidental changing of this value by a root service.
> > 
> > The config is disabled by default to avoid surprises.
> 
> Can you elaborate why we care about "accidental changing of this value by a
> root service"?

Accidental... malicious...  Note that when people run programs as root with
reduced or no capabilities they can still write this file.

> We cannot really stop root from doing a lot of stupid things (e.g., erase
> the root fs), so why do we particularly care here?

Regardless of the "real value" of it, I know for a fact there are lots
of teams out there adding kernel patches to just change the mode of that
file.  Why?  Possibly to satisfy a scanner, because another team says
it's important.

The problem with lockdown is it's all or nothing.  The problem with LSM
for this purpose is that everyone will have to configure their policy
differently.

So I do think it was worth testing the waters with this patch, to reduce
the number of duplicate patches people run with.

-serge
