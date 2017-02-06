From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com>
	<1486055094-4532-2-git-send-email-djalal@gmail.com>
In-Reply-To: <1486055094-4532-2-git-send-email-djalal@gmail.com>
Message-Id: <201702061949.HGE43791.FFFtJVSHQOOLOM@I-love.SAKURA.ne.jp>
Date: Mon, 6 Feb 2017 19:49:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC/PATCH 1/3] security: add the security_task_copy() hook
To: tixxdz@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, keescook@chromium.org, akpm@linux-foundation.org, wluikil@gmail.com, dongsu@endocode.com, luto@kernel.org, james.l.morris@oracle.com, serge@hallyn.com, viro@zeniv.linux.org.uk, daniel@zonque.org, jann@thejh.net, elena.reshetova@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Djalal Harouni wrote:
> To achieve the above we add the security_task_copy() hook that allows us
> to clone the Timgad context of parent into child task_struct.
> 
> The security hook can also be used by new LSMs after the child task has
> done some initialization, this way they won't clash with the major LSMs.
> The situation is not really well, this hook allows us to introduce a
> stackable LSM that can be easily used with all other LSMs.

We are already planning to revive security_task_alloc() hook (probably in Linux 4.12)
( news://news.gmane.org:119/201701101958.JAD43709.OtJSOQFVFOLHMF@I-love.SAKURA.ne.jp ).
Is security_task_alloc() called too early for your case?

(Well, we want to configure http archive like marc.info ?)
