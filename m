Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 May 2016 12:53:11 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160518125311.311f970310f5e0080d690d17@gmail.com>
In-Reply-To: <573C26DC.6020607@au1.ibm.com>
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
	<20160513015833.cfb5334d075525b27269649c@gmail.com>
	<573C26DC.6020607@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v8 3/4] Add Cyclomatic complexity GCC
 plugin
To: kernel-hardening@lists.openwall.com
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 18 May 2016 18:25:00 +1000
Andrew Donnellan <andrew.donnellan@au1.ibm.com> wrote:

> On 13/05/16 09:58, Emese Revfy wrote:
> > Add a very simple plugin to demonstrate the GCC plugin infrastructure. This GCC
> > plugin computes the cyclomatic complexity of each function.
> 
> ...
> 
> > +config GCC_PLUGIN_CYC_COMPLEXITY
> > +	bool "Compute the cyclomatic complexity of a function"
> > +	depends on GCC_PLUGINS
> > +	help
> > +	  The complexity M of a function's control flow graph is defined as:
> > +	   M = E - N + 2P
> > +	  where
> > +
> > +	  E = the number of edges
> > +	  N = the number of nodes
> > +	  P = the number of connected components (exit nodes).
> > +
> 
> If this plugin is intended primarily as a demonstration it's probably 
> worth mentioning this in the Kconfig description.

Hi,

Before sancov this plugin demonstrated the gcc plugin infrastructure but otherwise this is a fully working plugin not a test plugin. Also it doesn't demonstrate all aspects of writing gcc plugins.

-- 
Emese
