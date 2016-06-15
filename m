Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2016 22:53:31 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160615225331.abb990e0302757ea9a6a3500@gmail.com>
In-Reply-To: <041e2196-2213-725d-64aa-8526b23bc618@redhat.com>
References: <20160524000719.b456ed0cd2aafacb4e53f177@gmail.com>
	<20160524001035.081cbf822a62b274ad945dc1@gmail.com>
	<041e2196-2213-725d-64aa-8526b23bc618@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v9 3/4] Add Cyclomatic complexity GCC plugin
To: Laura Abbott <labbott@redhat.com>
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com, minipli@ld-linux.so
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 14 Jun 2016 12:29:59 -0700
Laura Abbott <labbott@redhat.com> wrote:

> On 05/23/2016 03:10 PM, Emese Revfy wrote:
> 1) make mrproper
> 2) make defconfig
> 3) enable GCC_PLUGINS, GCC_PLUGIN_CYC_COMPLEXITY
> 4) enable FUNCTION_TRACER (it will select other options as well)
> 5) make && make modules
> 
> ERROR: "__fentry__" [net/ipv4/netfilter/ipt_MASQUERADE.ko] undefined!
> ERROR: "__fentry__" [fs/efivarfs/efivarfs.ko] undefined!
> ERROR: "__fentry__" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!
> scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> make[1]: *** [__modpost] Error 1

The patch below fixes this bug, but I think it is ugly.
https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/73e2d117daa7f3c6aee8935ecbb318354ff9cd82

If anyone has a better idea to fix this, please let me know.

Thanks
-- 
Emese
