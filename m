Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Dec 2011 14:22:40 -0800
From: Kees Cook <kees@ubuntu.com>
Message-ID: <20111219222240.GH12321@outflux.net>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org>
 <1324017197-3292-3-git-send-email-keescook@chromium.org>
 <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
 <20111219194136.GG12321@outflux.net>
 <alpine.LRH.2.00.1112200751260.30800@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1112200751260.30800@tundra.namei.org>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi James,

On Tue, Dec 20, 2011 at 07:52:34AM +1100, James Morris wrote:
> We should not see YAMA-specific code in the core kernel.  However you do 
> it, the above should happen in LSM.

Okay, I've removed the pid-ns logic for now. Vasiliy and I can readdress
this at a later time.

Thanks,

-Kees

-- 
Kees Cook
