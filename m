Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 12 Apr 2016 11:46:07 -0600
From: David Brown <david.brown@linaro.org>
Message-ID: <20160412174607.GA92143@davidb.org>
References: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v6 0/6] Introduce GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 07, 2016 at 11:10:23PM +0200, Emese Revfy wrote:
>This patch set introduce the GCC plugin infrastructure with examples for testing
>and documentation.
>
>GCC plugins are loadable modules that provide extra features to the compiler.
>They are useful for runtime instrumentation and static analysis.
>
>The infrastructure supports all gcc versions from 4.5 to 6.0, building
>out-of-tree modules and building in a separate directory. Cross-compilation
>is supported too but currently only the x86, arm and arm64 architectures enables plugins.
>
>This infrastructure was ported from grsecurity/PaX. It is a CII project
>supported by the Linux Foundation.
>
>Emese Revfy (6):
> Shared library support
> GCC plugin infrastructure
> The GCC plugin infrastructure supports the arm and arm64 architectures too
> Add Cyclomatic complexity plugin
> Documentations of the GCC plugin infrastructre
> Add sancov plugin

I've tested the v6 patches on arm, and partially on arm64.  The arm64
gcc has a bug in make install that doesn't install all necessary
headers to build plugins.  I believe the patch will work once that
version gets out.  It does, however, print a helpful message now
explaining the likely cause of the failure.

Tested-by: David Brown <david.brown@linaro.org>
