Message-ID: <1486734003.2096.32.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Fri, 10 Feb 2017 08:40:03 -0500
In-Reply-To: <20170210100902.11765-5-me@jessfraz.com>
References: <20170210100902.11765-1-me@jessfraz.com>
	 <20170210100902.11765-5-me@jessfraz.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 4/4] time: mark syscore_ops as
 __ro_after_init
To: Jess Frazelle <me@jessfraz.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-02-10 at 02:09 -0800, Jess Frazelle wrote:
> Marked syscore_ops structs as __ro_after_init when
> register_syscore_ops was
> called only during init. Most of the caller functions were already
> annotated as
> __init.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jess Frazelle <me@jessfraz.com>

Acked-by: Rik van Riel <riel@redhat.com>
