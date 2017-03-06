Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 6 Mar 2017 15:16:35 -0500
From: Tejun Heo <tj@kernel.org>
Message-ID: <20170306201635.GJ19696@htj.duckdns.org>
References: <20170225095648.GA4917@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170225095648.GA4917@beast>
Subject: [kernel-hardening] Re: [PATCH] cgroups: censor kernel pointer in debug files
To: Kees Cook <keescook@chromium.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 25, 2017 at 01:56:48AM -0800, Kees Cook wrote:
> As found in grsecurity, this avoids exposing a kernel pointer through
> the cgroup debug entries.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to cgroup/for-4.11-fixes.

Thanks.

-- 
tejun
