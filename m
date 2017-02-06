In-Reply-To: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>
From: Michael Ellerman <patch-notifications@ellerman.id.au>
Message-Id: <3vHK5Y5hnJz9s7G@ozlabs.org>
Date: Tue,  7 Feb 2017 07:37:05 +1100 (AEDT)
Subject: [kernel-hardening] Re: [1/3] gcc-plugins: fix definition of DISABLE_LATENT_ENTROPY_PLUGIN
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, re.emese@gmail.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, linux-kernel@vger.kernel.org, mmarek@suse.com, linux-kbuild@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-12-06 at 06:27:58 UTC, Andrew Donnellan wrote:
> The variable DISABLE_LATENT_ENTROPY_PLUGIN is defined when
> CONFIG_PAX_LATENT_ENTROPY is set. This is leftover from the original PaX
> version of the plugin code and doesn't actually exist. Change the condition
> to depend on CONFIG_GCC_PLUGIN_LATENT_ENTROPY instead.
> 
> Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/7b4010edff09929c253e6626ab19ca

cheers
