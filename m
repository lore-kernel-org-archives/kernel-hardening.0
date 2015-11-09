Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 08:42:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20151109054253.GQ18797@mwanda>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>
 <20151108221624.GP18797@mwanda>
 <alpine.DEB.2.10.1511082220500.2583@hadrien>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1511082220500.2583@hadrien>
Subject: [kernel-hardening] Re: [PATCH] video: constify geode ops structures
To: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 08, 2015 at 10:24:49PM +0000, Julia Lawall wrote:
> On Mon, 9 Nov 2015, Dan Carpenter wrote:
> 
> > Cool.  So, in grsec they use a GCC plugin to make these const
> > automatically since they only contain function pointers.  There about
> > 100 struct types marked as __no_const.  Kees would like to adopt the
> > grsec pluggin approach I expect.  Do you have an idea how many structs
> > only contain function pointers or how many consts we would have to add
> > to get the same effect without the plugin?
> 
> My list has 373 type names.  In the list there are counts for good
> (already const) and bad (not const).  The sum of the bad values is 2467.
> The list is below.
> 
> julia

Fantastic!  Thanks.  We could autogenerate the list of type names and
make checkpatch.pl complain if we declared those types as non const.

I ran this command to find which functions grsec marks as __no_const.

egrep '(^ struct |^@@|__no_const;)' grsecurity-3.1-4.2.5-201511021814.patch | grep __no_const -B1 | grep -v __no_const | grep -v '^--' | cut -d @ -f 5-  | cut -b 9- | cut -d ' ' -f 1

There are 60 structs declared as __no_const.  For some structs they
declare a no_const version and use it as needed.  Like this:
typedef struct net_device_ops __no_const net_device_ops_no_const;

grep __no_const grsecurity-3.1-4.2.5-201511021814.patch | grep typedef | cut -d ' ' -f 3

There are 32 of those.

Then I compared to see if their structs were on your list.  For some
reason there quite a few one their list which are not on yours.  Out
of the first 10 about half weren't on your list.  cpu_cache_fns,
outer_cache_fns, psci_operations, smp_operations, omap_hwmod_soc_ops,
smp_ops_t.  These are mostly different arches?

Also bit_table has in int has well as a function pointers but it is on
their list.  I'm not sure why.  Maybe they are marking structs const
that I don't know about.

The other trick that they do is they define structs as __do_const if
they want them to be const by default, which is pretty neat.  This feels
like it should be a standard GCC feature.  In the meantime we could
mark things as __do_const and print a sparse warning if it was declared
as not const.

I have attached the list of __no_const structs.

regards,
dan carpenter



--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=no_const

cpu_cache_fns
cpuidle_ops
outer_cache_fns
cpu_user_fns
psci_operations
smp_operations
cpu_pm_ops
omap_hwmod_soc_ops
smp_ops_t
machine_ops
smp_ops
x86_init_ops
x86_cpuinit_ops
x86_platform_ops
x86_msi_ops
x86_io_apic_ops
cryptd_blkcipher_request_ctx
cryptd_aead_request_ctx
od_ops
amd_decoder_ops
kernel_queue_ops
bit_table
af9033_ops
dib_fe_xfer_ops
dib7000p_ops
dib8000_ops
xpc_interface
l2t_skb_cb
ath10k_htc_ops
ath10k_htc_ep_ops
ath_hw_private_ops
ath_hw_ops
bfa_itn_s
bfa_ioc_cbfn_s
bfa_ioc_hwif_s
fbtft_ops
ldlm_callback_suite
md_ops
hal_ops
_io_ops
visorchipset_busdev_notifiers
visorchipset_busdev_responders
via_clock
drm_encoder_helper_funcs
ttm_mem_shrink
cleancache_ops
cipher_tfm
compress_tfm
softirq_action
gpd_dev_ops
rchan_callbacks
rio_ops
renesas_usbhs_driver_callback
cfctrl_rsp
iw_cm_verbs
snd_compr_ops
lane2_ops
rtnl_link
tipc_nl_compat_cmd_dump
tipc_nl_compat_cmd_doit

Sometimes not const:

fw_card_driver
dm_space_map
v4l2_ioctl_info
xpc_arch_operations
drm_info_list
clk_ops
global_attr
cpuidle_state
device_attribute
efivar_operations
fb_ops
file_operations
sensor_device_attribute
sensor_device_attribute_2
i2c_algorithm
irq_chip
irq_chip
kobj_attribute
vm_operations_struct
module_attribute
net_device_ops
notifier_block
hotplug_slot_ops
dev_pm_domain
user_regset
seq_operations
ctl_table
attribute
attribute_group
bin_attribute
libfc_function_template
fc_function_template

--17pEHd4RhPHOinZp--
