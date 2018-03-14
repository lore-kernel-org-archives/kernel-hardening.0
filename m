Date: Wed, 14 Mar 2018 16:42:48 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: drop a VLA in btrfs_check_super_csum()
Message-ID: <20180314154248.GL32007@twin.jikos.cz>
References: <1520970622-19535-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520970622-19535-1-git-send-email-s.mesoraca16@gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 13, 2018 at 08:50:22PM +0100, Salvatore Mesoraca wrote:
> Avoid a VLA[1] by using a real constant expression instead of a variable.
> The compiler should be able to optimize the original code and avoid using
> an actual VLA. Anyway this change is useful because it will avoid a false
> positive with -Wvla, it might also help the compiler generating better
> code.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

We already have a patch for that from a few days ago, but thanks anyway.

https://patchwork.kernel.org/patch/10277901/
