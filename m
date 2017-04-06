Date: Fri, 7 Apr 2017 07:54:17 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.20.1704070749440.27111@namei.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] [PATCH 00/18] Introduce struct layout
 randomization plugin
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 6 Apr 2017, Kees Cook wrote:

> third party kernel module builds), it still has some value there since
> now all kernel builds would need to be tracked by an attacker.

I don't see this case as providing any value.  Tracking a bunch of known 
seed values seems like a pretty low bar for an attacker.



- James
-- 
James Morris
<jmorris@namei.org>
