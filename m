Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 19 Nov 2011 20:30:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111119163058.GA3131@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <1319672956-17114-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319672956-17114-4-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 3/3] security: Yama: add ptrace relationship tracking
 interface
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

Thank you for working on this!  We'll use Yama in Openwall too :-)

On Wed, Oct 26, 2011 at 16:49 -0700, Kees Cook wrote:
> +	if (mode == PTRACE_MODE_ATTACH &&
> +	    ptrace_scope &&
> +	    !capable(CAP_SYS_PTRACE) &&
> +	    !task_is_descendant(current, child) &&
> +	    !ptracer_exception_found(current, child))
> +		rc = -EPERM;

capable() is better to put after all other tests as a failed capable()
might emit a false positive warning into logs or something.

Thanks,

-- 
Vasiliy
