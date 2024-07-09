### A Pluto.jl notebook ###
# v0.19.43

#> [frontmatter]
#> title = "MaxEntropyGraphs.jl"
#> date = "2024-07-10"
#> description = "JuliaCon 2024 demo"
#> 
#>     [[frontmatter.author]]
#>     name = "Bart De Clerck"
#>     url = "https://github.com/B4rtDC/MaxEntropyGraphs.jl"

using Markdown
using InteractiveUtils

# ╔═╡ 0fd958de-27b5-40bf-bcc8-523558022291
begin
	using PlutoUI

	TableOfContents(title="MaxEntropyGraphs.jl")
end

# ╔═╡ c8086d4f-dae4-429d-9fe8-fbad153949ac
using MaxEntropyGraphs, Graphs, Statistics, Plots, StatsPlots

# ╔═╡ 6810f92f-a328-4a38-9401-ed5f909e6223
html"""
 <! -- this adapts the width of the cells to display its being used on -->
<style>
	main {
		margin: 0 auto;
		max-width: 2000px;
    	padding-left: max(160px, 10%);
    	padding-right: max(160px, 10%);
	}
</style>
"""

# ╔═╡ faadea64-c4e4-4d60-8e1e-8069e90ce473
html"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Awesome Webpage</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        h1 {
            color: #333;
            font-size: 48px;
            margin: 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>MaxEntropyGraphs.jl (JuliaCon 2024)</h1>
</body>
</html>
"""

# ╔═╡ c61d36ad-9577-44f7-bbfd-ebff93571c22
html"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Profile</title>
    <style>
        .container {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .profile {
            border: 1px solid #ccc;
            padding: 20px;
            max-width: 300px;
            text-align: center;
            font-family: Arial, sans-serif;
            margin-right: 20px;
        }
        .profile img {
            border-radius: 50%;
            width: 100px;
            height: 100px;
        }
        .qr-code {
            width: 300px;
            height: 300px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div id="profile" class="profile"></div>
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1920px-QR_code_for_mobile_English_Wikipedia.svg.png" alt="QR Code" class="qr-code">
    </div>

    <script>
        async function fetchProfile(username) {
            const response = await fetch(`https://api.github.com/users/${username}`);
            const profile = await response.json();
            const profileDiv = document.getElementById('profile');
            profileDiv.innerHTML = `
                <img src="${profile.avatar_url}" alt="${profile.login}">
                <h2>${profile.name}</h2>
                <a href="${profile.html_url}" target="_blank">View GitHub Profile</a>
            `;
        }

        fetchProfile('B4rtDC');
    </script>
</body>
</html>

"""

# ╔═╡ 60e3b179-4f50-45be-a331-1e351512d41e
md"""
# Concepts
## Compatible graphs
Undirected
$(PlutoUI.Resource("https://upload.wikimedia.org/wikipedia/commons/b/bf/Undirected.svg", :width => 200))
Directed
$(PlutoUI.Resource("https://upload.wikimedia.org/wikipedia/commons/a/a2/Directed.svg", :width => 200))

Bipartite
$(PlutoUI.Resource("https://upload.wikimedia.org/wikipedia/commons/d/d4/Biclique_K_3_5_bicolor.svg", :width => 350))


## Random graphs
Generate a graph ensemble that is random except for some constraints $\left( C(\cdot) \right)$ observed on $G^{*}$. 

This leads to a distribution: $\sum_{G \in \mathcal{G}} P(G) = 1$.


We consider two types of constraints:
* hard constraints:
```math
 \forall G \in \mathcal{G} : P(G) = \begin{cases}
        \frac{1}{\vert \mathcal{G} \vert} & \text{if } \mathbf{C}(G) = \mathbf{C}(G^{*}); \\ 
        0 & \text{otherwise}.
    \end{cases}
```
* soft constraints:
```math
\mathbf{C}(\mathcal{G}) = \langle \mathbf{C} \rangle = \sum_{G \in \mathcal{G}} \mathbf{C}(G)P(G) = \mathbf{C}(G^{*})
```


### Maximum entropy ensemble
```math
\max  S = - \sum_{G\in \mathcal{G}} P(G) \ln{ P(G)},
```
subject to: 
```math
\begin{cases}
\sum_{G \in \mathcal{G}} P(G) = 1 \\
\sum_{G\in \mathcal{G}} P(G) C_i = \langle C_i \rangle \text{ for } i = 1\dots \vert \mathbf{C} \vert
\end{cases}
```

The above equations lead to the optimisation problem that needs to be solved.

Every set of constraints represents a different model, for which the likelihood maximising parameters need to be determined. Once these are known, we can either directly compute ensemble averages and standard deviations, or sample the ensemble.

This framework allows us to compute:
- expected values of a metric $X$
- variance of a metric $X$,

directly from the ensemble, as long as we can write the metric in function of the adjacency matrix.
"""

# ╔═╡ 56ce2010-c593-4e53-aa75-30c9eb8246f9
md"""
## Use cases
- Anomaly detection
- Subgraph counts
- Validated projections of a bipartite graph
- ...

"""

# ╔═╡ 93cc0d87-0420-47fd-8f9a-633c93cbc9ef
md"""
# Architecture
## But doesn't this already exist in other languages?
Yes but...
"""

# ╔═╡ 89618fb7-88ab-4eb7-ba27-f397f82e8a4d
html"""<table>
  <tr>
    <td><img src="https://i.redd.it/tsmvuu8kmmy31.jpg" alt="Matlab" /></td>
    <td><img src="https://i.imgur.com/JuqfJ5X.png" alt="Python" /></td>
    <td><img src="https://i.imgur.com/AzYEVGk.png" alt="Julia" /></td>
  </tr>
  <tr>
    <td>
      <ul>
        <li>Software license</li>
        <li>Package documentation</li>
        <li>Sampled graphs = adjacency matrices</li>
		<li>Limited graph analysis functionality</li>
        <li>...</li>
      </ul>
    </td>
    <td>
      <ul>
        <li>The joys of dependency management</li>
        <li>Sampled graphs = edge list txt file</li>
		<li>"DIY" numerical solvers</li>
		<li>"DIY" statistical analysis</li>
		<li>Python + Numba + Cython + Graph package + ....</li>
		<li>Limited graph analysis functionality</li>
		<li>Hardcoded gradients & hessians (faster, but error prone!)</li>
      </ul>
    </td>
    <td>
	  <ul>
		<li>Native Julia!</li>
		<li>Julia package manager!</li>
		<li>Documenter!</li>
        <li>JuliaGraphs integration, i.e. sampled graphs: <code><:AbstractGraph</code></li>
		<li>High quality numerical solvers => better convergence!</li>
        <li>Standardised API, e.g. <code>rand(m::M) where M<:AbstractMaxEntropyModel</code></li>
		<li>Easy and efficient multithreading</li>
		<li>Leverage JuliaDiff</li>
 		<li>...</li>
      </ul>
	</td>
  </tr>
</table>"""

# ╔═╡ 966eba08-f630-46e0-988e-800d24a70b77
md"""
## Overview
$(Resource("https://i.imgur.com/0lUkyk9.png"))

Specific performance details:
- Use of buffers wherever possible
- [PreCompileTools.jl](https://julialang.github.io/PrecompileTools.jl/stable/) for "single use functions"
"""

# ╔═╡ a0e57d8c-85d5-4aeb-a537-5354bb3578bf
md"""
# Usage
"""

# ╔═╡ 8bf54ab7-1005-4e12-becc-9012c80a0d43
md"""

## Undirected graph
"""

# ╔═╡ 37a2163c-5c32-4e51-980b-1cd8de386675
begin
	# Define the graph
	G = smallgraph(:karate)
	
	# Generate a model that imposes the degree sequence as constraints (on average)
	model = UBCM(G)

	# Compute its likelihood maximising parameters (default settings)
	solve_model!(model)

	# Generate a sample from the ensemble
	S = rand(model, 1000)

	nothing
end

# ╔═╡ e389d224-e93f-49e1-8f03-8e1e77dbbd98
md"""
We now have our model with its computed parameters. 

By default, the expected values and the variance of graph's adjacency matrix are not computed, in order to save memory. If needed, the values can be computed on the fly.
"""

# ╔═╡ 1af46182-5888-4b58-bc63-681362f794c0
begin 
	# compute and set the expected adjacency matrix
	set_Ĝ!(model) 
	
	# compute and set the standard deviation of the adjacency matrix
	set_σ!(model)

	nothing
end

# ╔═╡ 00bc5aa2-514b-41be-b31c-d8517bd13481
md"""
Suppose we want to check for degree assortativity, i.e. do nodes with a high degree tend to connect with other high-degree nodes ?

We can quantify this through the average nearest neighbor degree (ANND). This metric is available in the package.
"""

# ╔═╡ a86d6113-c298-43fe-9396-a7ccd553d1b8
begin
	# degree of each node in the observed graph
	k = degree(G)
	
	# ANND for each node in the observed graph
	ANND_obs = ANND(G)
	
	# ANND for each node in the sample
	ANND_S = hcat(ANND.(S)...)

	nothing
end

# ╔═╡ 21b99047-2a60-4433-9421-d03a8b529664
md"""
We can illustrate this graphically:
"""

# ╔═╡ c81c72c6-2b7c-4396-a214-9525b879e6ca
begin
	# outlier computation
	α = 0.05
	p_small = [(1 + sum(ANND_obs[i] .> ANND_S[i,:])) / (1 + size(ANND_S,2)) for i in 1:nv(G)]
	small_outliers = p_small .< α
	p_large = [(1 + sum(ANND_obs[i] .< ANND_S[i,:])) / (1 + size(ANND_S,2)) for i in 1:nv(G)]
	large_outlliers = p_large .< α

	# plot
	plot()
	for i in eachindex(k)
		if small_outliers[i] || large_outlliers[i]
			scatter!([k[i]], [ANND_obs[i]], xlabel="Degree", ylabel="ANND", label="", color=:red)
		else
			scatter!([k[i]], [ANND_obs[i]], xlabel="Degree", ylabel="ANND", label="", color=:blue)
		end
		boxplot!([k[i]], ANND_S[i,:], label="", color=:gray, alpha=0.1)
	end

	scatter!([],[], label="observed", color=:blue)
	scatter!([],[], label="observed, statistically significant", color=:red)
	boxplot!([],[],label="Sample distribution", color=:gray, alpha=0.1)
end

# ╔═╡ 6e1b8c79-70fb-47ed-a048-2ddccb4a00f3
md"""
Our graph appears to be disasortative, with the three highest degree nodes having a lower ANND than what you would expect under the null model.
"""

# ╔═╡ 5428e10b-2f42-4798-ade3-648aad5162cb
md"""
## Directed graph
In biology and economy, one often analyses the occurence of triadic subgraphs.

$(Resource("https://i.imgur.com/4CODs3t.png", :width =>600 ))

Some known foodwebs from the literature are available in the package.
"""

# ╔═╡ d3bafba4-7273-4380-b5b9-1defd00eae5f
begin
	# Define the graph
	G_d = chesapeakebay()

	# Define the model
	model_d = DBCM(G_d)
	
	# compute the maximum likelihood parameters
	solve_model!(model_d)

	# generate a sample
	S_d = rand(model_d, 1000)
	
	nothing
end

# ╔═╡ 4a281bfa-2390-4dd8-96c2-6c1e89bf10fe
md"""
Focussing on one specific metrix `X` (in this case the counts of triadic pattern 13), we can consider expected values and standard deviations.

**Note:** when doing this on an ensemble level, the ensembles expected adjacency matrix must be determined.
"""

# ╔═╡ 751543bd-eeae-416c-b8b1-55dce90302c5
set_Ĝ!(model_d), set_σ!(model_d); nothing

# ╔═╡ d7b31b52-931b-4cbf-81f9-73aa07b5e8bb
md"""
As before, we can compute the expected values based on the ensemble and based on the sample.
"""

# ╔═╡ d2740c1d-be9e-4115-801d-2a7c83d5977b
begin
	# pick the metric function
	X = M4
	
	# get the estimate from the ensemble
	X̂_e = X(model_d)
	
	# get the standard deviation from the ensemble
	σ_X_e = σₓ(model_d, X)

	# get a z-score for the ensemble:
	z_e = (X(G_d) - X̂_e) / σ_X_e

	# get the estimate from the sample
	X̂_s = mean(X.(S_d))

	# get the estimate from the sample
	σ_X_s = std(X.(S_d))

	# get a z-score from the sample
	z_s = (X(G_d) - X̂_s) / σ_X_s

	nothing
end

# ╔═╡ f94f51f6-6f18-4a23-a000-e08aa3ab194a
md"""
The result can also be visualised:
"""

# ╔═╡ f6fa24cf-c479-4ee9-bbcc-5069761b49e8
begin
	scatter([1], [X(G_d)], label="Observed (z_e = $(round(z_e, digits=2)), z_s = $(round(z_s, digits=2)))") 
	boxplot!([1], X.(S_d), label="Sample", alpha=0.5)
	plot!(xticks=([1], ["$(X)"]), xlims=(0, 3), ylabel="$(X) count")
end

# ╔═╡ 38fd94bc-2e14-4087-aefd-7fe4835528c7
md"""
## Bipartite graph
Bipartite graphs in this framework have seen many domains, including [economy](https://www.nature.com/articles/srep10595#Abs1), [medicine](https://www.nature.com/articles/s41598-023-46184-y#Abs1), and [social media analysis](https://academic.oup.com/pnasnexus/article/3/5/pgae177/7658380#). In many cases, [extracting a validated monopartite network](https://iopscience.iop.org/article/10.1088/1367-2630/aa6b38) is used to obtain a better understanding of the system under investigation.


$(Resource("https://i.imgur.com/yBw4oCT.png", :width => 800))

Bipartite network and its projections.
"""

# ╔═╡ 202db463-d177-4210-b02a-df0423985ca6
md"""
**Note**: There is a hidden cell containing the edgelist for the [crime network](http://konect.cc/networks/moreno_crime/).
"""

# ╔═╡ f4bc2242-743c-41da-b48e-57503eaa5dd7
begin
	crime_edges = Edge.([(1, 830), (1, 831), (1, 832), (1, 833), (2, 834), (2, 835), (2, 836), (2, 837), (2, 838), (2, 839), (2, 840), (2, 841), (2, 842), (2, 843), (2, 844), (2, 845), (2, 846), (2, 847), (2, 848), (2, 849), (2, 850), (2, 851), (2, 852), (2, 853), (2, 854), (2, 855), (3, 856), (4, 853), (5, 848), (6, 857), (7, 858), (8, 859), (9, 860), (10, 861), (10, 862), (10, 863), (10, 864), (10, 865), (10, 866), (10, 867), (10, 868), (11, 860), (12, 869), (12, 870), (12, 871), (13, 871), (14, 871), (15, 872), (16, 873), (17, 874), (17, 875), (17, 876), (17, 877), (17, 878), (18, 879), (19, 880), (20, 880), (21, 881), (21, 882), (22, 883), (23, 884), (24, 885), (25, 885), (26, 886), (27, 887), (28, 888), (29, 889), (30, 890), (31, 891), (32, 892), (33, 837), (33, 839), (34, 893), (35, 892), (36, 894), (37, 895), (37, 896), (37, 894), (37, 897), (37, 898), (37, 899), (37, 900), (37, 901), (38, 902), (39, 851), (40, 903), (40, 904), (41, 905), (41, 904), (42, 859), (43, 906), (44, 907), (45, 908), (45, 909), (46, 910), (46, 911), (47, 912), (48, 913), (48, 853), (49, 914), (50, 915), (51, 916), (51, 917), (51, 918), (51, 919), (51, 920), (51, 921), (52, 922), (53, 923), (54, 924), (54, 925), (54, 926), (54, 923), (55, 908), (56, 927), (56, 928), (56, 929), (56, 930), (56, 931), (56, 932), (56, 863), (56, 933), (56, 934), (56, 935), (56, 936), (56, 937), (56, 938), (56, 939), (57, 879), (57, 933), (57, 937), (58, 879), (58, 937), (59, 939), (60, 940), (61, 941), (62, 942), (62, 943), (62, 944), (62, 945), (62, 946), (62, 893), (63, 947), (64, 948), (65, 949), (66, 865), (67, 841), (67, 844), (67, 845), (67, 849), (68, 950), (69, 864), (70, 864), (71, 902), (72, 951), (73, 857), (73, 872), (74, 952), (74, 951), (74, 953), (74, 954), (74, 919), (74, 920), (74, 939), (75, 955), (76, 924), (77, 927), (77, 956), (78, 957), (78, 958), (79, 959), (79, 960), (79, 961), (79, 962), (79, 963), (79, 964), (80, 907), (81, 868), (82, 965), (82, 868), (82, 886), (83, 966), (84, 967), (85, 968), (86, 969), (87, 970), (87, 971), (87, 972), (87, 973), (88, 955), (88, 974), (88, 975), (88, 976), (88, 977), (88, 978), (88, 904), (88, 901), (89, 979), (89, 975), (89, 977), (90, 849), (91, 875), (92, 980), (93, 832), (94, 981), (95, 924), (96, 921), (97, 857), (97, 872), (98, 982), (99, 983), (100, 984), (101, 984), (101, 899), (102, 985), (103, 986), (104, 987), (104, 988), (105, 989), (106, 990), (106, 887), (106, 986), (107, 991), (108, 992), (108, 993), (108, 994), (108, 995), (108, 996), (108, 997), (109, 994), (110, 998), (111, 998), (112, 999), (112, 1000), (112, 919), (112, 1001), (113, 909), (114, 857), (114, 924), (115, 1002), (115, 1003), (115, 1004), (115, 1005), (115, 1006), (115, 1007), (115, 1008), (115, 1009), (115, 1010), (116, 917), (117, 1011), (117, 1012), (118, 1013), (119, 1013), (119, 1014), (120, 1015), (121, 894), (122, 1016), (123, 1017), (124, 1018), (125, 1019), (126, 1020), (127, 1021), (128, 1022), (128, 1023), (128, 1024), (128, 1025), (128, 939), (128, 1026), (129, 1022), (129, 1027), (129, 1028), (129, 1029), (129, 1015), (130, 865), (131, 1030), (131, 1018), (131, 1031), (131, 1032), (132, 1011), (133, 1033), (134, 1033), (135, 1034), (136, 1035), (137, 1036), (138, 1037), (139, 867), (140, 987), (141, 1038), (142, 1039), (143, 959), (144, 1040), (145, 891), (145, 981), (146, 1041), (146, 1042), (146, 1043), (146, 891), (146, 981), (146, 1044), (146, 1045), (146, 1046), (147, 1047), (148, 1048), (149, 982), (150, 1016), (151, 1001), (152, 1049), (152, 1018), (152, 968), (153, 1050), (154, 868), (155, 1051), (155, 1052), (155, 1053), (155, 1028), (155, 1029), (156, 885), (157, 981), (158, 1054), (159, 930), (159, 1036), (159, 1055), (159, 1056), (159, 1057), (159, 1058), (159, 1059), (160, 1036), (161, 976), (162, 1060), (162, 868), (163, 915), (164, 1061), (165, 940), (166, 945), (167, 1062), (167, 868), (168, 1063), (169, 1064), (170, 990), (171, 931), (171, 1065), (172, 1066), (173, 1067), (174, 1051), (174, 1052), (174, 1068), (174, 1069), (175, 1057), (176, 980), (177, 885), (178, 872), (179, 1070), (180, 994), (181, 1071), (182, 1044), (183, 1072), (184, 1061), (184, 901), (185, 872), (186, 851), (187, 1045), (188, 1073), (189, 1074), (190, 1075), (190, 1076), (190, 955), (190, 1077), (190, 1078), (190, 1079), (191, 886), (192, 1080), (193, 1081), (194, 1082), (195, 889), (196, 889), (197, 1083), (198, 1041), (199, 1084), (199, 1085), (200, 901), (201, 1086), (202, 1074), (202, 1047), (202, 969), (203, 1087), (204, 1088), (205, 927), (206, 1054), (207, 1089), (208, 984), (209, 1090), (210, 1054), (211, 843), (212, 1067), (213, 1091), (214, 1092), (214, 856), (214, 1093), (214, 1094), (214, 1095), (214, 1067), (214, 1096), (215, 1097), (216, 1093), (216, 1097), (216, 1096), (217, 1098), (218, 1099), (219, 982), (219, 1099), (219, 1100), (220, 948), (220, 1101), (220, 1102), (220, 1103), (220, 1104), (220, 1105), (220, 1106), (220, 1107), (220, 1108), (220, 1109), (220, 1110), (220, 1111), (220, 1112), (220, 1113), (220, 1114), (220, 1115), (220, 1116), (221, 1117), (221, 910), (221, 1118), (221, 1119), (222, 1120), (223, 835), (224, 868), (225, 861), (225, 1121), (225, 868), (226, 1122), (227, 1123), (228, 1124), (229, 1125), (230, 1054), (231, 1126), (232, 1126), (233, 945), (234, 926), (235, 926), (236, 1127), (237, 1128), (238, 1129), (239, 907), (240, 1130), (241, 1131), (242, 1132), (242, 967), (242, 1133), (242, 1134), (242, 1113), (243, 1002), (243, 1135), (244, 984), (244, 904), (245, 1136), (245, 1137), (245, 1138), (246, 941), (247, 1139), (247, 1061), (248, 1140), (249, 1033), (249, 1141), (250, 872), (251, 1127), (252, 1054), (253, 1142), (253, 1143), (254, 1100), (255, 967), (256, 990), (257, 1144), (258, 1145), (259, 1146), (260, 981), (261, 1147), (262, 943), (263, 1148), (264, 1092), (264, 1111), (265, 1149), (266, 1150), (267, 1151), (267, 1152), (268, 1153), (269, 975), (269, 1069), (270, 1035), (271, 1154), (272, 876), (273, 1155), (274, 875), (275, 940), (276, 1054), (277, 1156), (277, 1125), (277, 1157), (277, 1158), (277, 1159), (277, 1160), (277, 876), (278, 924), (279, 995), (280, 1161), (281, 892), (282, 862), (283, 1162), (283, 1080), (284, 930), (284, 1058), (285, 865), (286, 853), (287, 853), (288, 1163), (289, 865), (290, 1054), (291, 1164), (291, 1163), (291, 1165), (291, 1166), (291, 906), (291, 875), (291, 1167), (292, 1168), (293, 1169), (294, 1077), (294, 1086), (295, 1004), (296, 1170), (297, 1170), (297, 936), (298, 1170), (299, 859), (299, 906), (300, 855), (301, 1084), (302, 879), (303, 933), (303, 936), (303, 937), (304, 907), (304, 1143), (304, 1171), (304, 852), (305, 1142), (305, 843), (306, 872), (307, 1010), (308, 1172), (309, 846), (310, 1173), (311, 990), (312, 1174), (313, 998), (313, 1175), (314, 1172), (315, 1176), (315, 1177), (316, 900), (317, 1046), (318, 1122), (319, 911), (320, 840), (321, 1130), (322, 1161), (323, 1178), (324, 1129), (325, 1179), (326, 896), (326, 894), (327, 1098), (328, 898), (329, 1077), (330, 965), (331, 1087), (331, 868), (332, 868), (333, 1180), (333, 1181), (333, 946), (333, 1182), (334, 1070), (334, 1151), (335, 869), (335, 980), (336, 869), (336, 1183), (336, 1151), (336, 1184), (336, 1185), (336, 1186), (336, 875), (336, 1187), (336, 833), (337, 896), (338, 843), (338, 854), (339, 990), (340, 990), (341, 1188), (342, 1189), (343, 1129), (343, 940), (343, 1190), (343, 868), (344, 1191), (344, 1192), (344, 1144), (344, 1193), (344, 1194), (345, 1195), (345, 1196), (345, 1169), (345, 1197), (346, 924), (347, 881), (348, 897), (349, 1119), (350, 1198), (351, 1199), (351, 958), (351, 1150), (351, 1200), (352, 1201), (352, 1131), (352, 1202), (353, 1203), (354, 1204), (354, 1205), (355, 991), (356, 908), (356, 1016), (356, 1206), (356, 843), (356, 909), (356, 852), (356, 1207), (356, 1208), (356, 991), (356, 1209), (356, 1035), (357, 1095), (357, 1210), (358, 1046), (359, 1108), (360, 853), (361, 843), (361, 848), (362, 1049), (362, 944), (362, 1148), (363, 890), (363, 1211), (363, 938), (364, 981), (365, 872), (365, 1212), (366, 865), (367, 1080), (368, 916), (369, 1040), (370, 1213), (370, 1040), (370, 1214), (371, 1215), (371, 1216), (372, 1130), (373, 1217), (374, 862), (375, 1111), (376, 889), (377, 917), (378, 1092), (379, 1218), (380, 1219), (381, 1220), (381, 915), (381, 987), (381, 1221), (381, 1222), (381, 1223), (382, 1220), (383, 1221), (384, 912), (384, 983), (384, 1172), (384, 1098), (384, 1091), (384, 1182), (385, 1201), (386, 990), (387, 1065), (388, 1224), (389, 1010), (390, 1225), (391, 1035), (392, 1106), (392, 1226), (392, 1227), (393, 1226), (394, 1228), (395, 1229), (396, 1230), (396, 922), (396, 1231), (396, 1017), (396, 939), (397, 982), (397, 1232), (397, 1017), (397, 1161), (398, 967), (398, 1133), (399, 1061), (400, 875), (400, 1233), (401, 853), (402, 1234), (403, 1235), (404, 1236), (404, 1237), (404, 1018), (404, 884), (404, 998), (404, 880), (404, 1238), (404, 902), (404, 1234), (404, 1235), (405, 1239), (405, 884), (405, 998), (405, 1240), (406, 1147), (406, 1018), (406, 949), (407, 880), (408, 982), (409, 924), (410, 1241), (410, 1198), (410, 1103), (410, 1242), (411, 1243), (411, 1244), (411, 1245), (412, 933), (412, 935), (413, 924), (413, 1047), (413, 1246), (413, 1247), (413, 1212), (413, 1248), (414, 1249), (414, 1217), (414, 1168), (414, 1250), (414, 1178), (414, 1149), (414, 1251), (415, 1236), (415, 1237), (416, 1119), (417, 890), (418, 908), (418, 1016), (419, 873), (420, 1252), (420, 1253), (421, 1254), (422, 1254), (423, 1254), (424, 910), (424, 876), (425, 872), (425, 924), (425, 1255), (425, 1256), (425, 1257), (425, 1258), (425, 1047), (425, 888), (425, 1259), (425, 1246), (425, 925), (425, 1064), (425, 1260), (425, 939), (425, 1248), (425, 1261), (425, 1146), (425, 923), (426, 1227), (427, 1123), (428, 1262), (429, 1263), (430, 1264), (431, 1086), (432, 862), (433, 909), (434, 1265), (435, 1266), (435, 868), (436, 990), (437, 1234), (437, 1235), (438, 916), (439, 1092), (439, 843), (439, 1261), (440, 1010), (441, 1262), (441, 1014), (442, 1267), (443, 1054), (444, 907), (445, 907), (446, 907), (447, 923), (448, 1070), (449, 924), (449, 850), (450, 1268), (451, 943), (452, 1269), (452, 946), (452, 1270), (453, 1271), (454, 1271), (454, 1219), (455, 1271), (456, 896), (457, 1010), (458, 1272), (459, 906), (460, 1242), (461, 1217), (462, 891), (463, 891), (464, 891), (465, 1080), (466, 883), (466, 1138), (466, 1071), (467, 858), (468, 941), (469, 1091), (470, 1078), (470, 873), (471, 851), (472, 1018), (472, 1273), (472, 1274), (473, 982), (474, 1275), (474, 1276), (474, 1218), (474, 1277), (474, 1278), (474, 1279), (474, 1048), (474, 1280), (474, 946), (475, 843), (476, 1239), (476, 1234), (477, 982), (478, 1072), (479, 990), (480, 859), (481, 1217), (481, 1091), (482, 1264), (483, 1168), (484, 982), (485, 1281), (486, 858), (487, 982), (488, 1276), (489, 1019), (490, 1282), (490, 1261), (491, 1280), (492, 1280), (493, 879), (494, 1041), (495, 842), (496, 941), (497, 1283), (497, 1284), (497, 857), (497, 1285), (497, 872), (497, 924), (497, 1212), (497, 1039), (497, 1116), (498, 843), (499, 848), (500, 1286), (501, 1287), (502, 1288), (502, 1289), (502, 1290), (502, 1287), (502, 1286), (503, 1173), (504, 944), (505, 945), (506, 915), (507, 1185), (508, 1211), (509, 1190), (510, 1274), (511, 919), (511, 1001), (512, 1291), (512, 1292), (512, 1050), (513, 1293), (513, 1294), (514, 1213), (514, 1295), (514, 1296), (514, 1297), (514, 1298), (514, 874), (514, 875), (514, 877), (514, 878), (514, 1299), (514, 1149), (515, 1300), (515, 1301), (515, 954), (515, 1128), (516, 1264), (517, 926), (518, 1200), (519, 1190), (520, 865), (521, 1302), (522, 984), (523, 901), (524, 1124), (524, 1298), (525, 890), (526, 1035), (527, 890), (528, 855), (529, 1199), (530, 1271), (531, 1303), (531, 1023), (531, 1024), (531, 1230), (531, 1304), (531, 1231), (531, 1025), (531, 939), (531, 1026), (531, 1305), (532, 1306), (532, 1307), (533, 1027), (533, 1290), (533, 1025), (533, 1308), (533, 1189), (533, 939), (534, 1309), (535, 1310), (536, 1033), (536, 1311), (536, 882), (536, 1037), (536, 876), (537, 1043), (538, 1126), (539, 909), (540, 1312), (541, 1043), (542, 907), (543, 1313), (543, 1113), (543, 1314), (544, 865), (545, 865), (546, 1041), (547, 1125), (548, 1315), (549, 1316), (549, 860), (549, 881), (549, 1315), (549, 950), (549, 1265), (549, 889), (550, 920), (551, 1281), (552, 1074), (553, 1048), (554, 1031), (555, 1222), (556, 871), (557, 858), (558, 1199), (559, 1119), (560, 1147), (561, 1317), (561, 1318), (562, 982), (563, 843), (563, 1309), (564, 1309), (565, 1101), (566, 872), (567, 1319), (567, 911), (567, 1224), (568, 864), (568, 866), (569, 879), (570, 870), (571, 896), (572, 1289), (572, 1290), (572, 1308), (572, 1320), (572, 1321), (572, 1189), (572, 939), (573, 1270), (574, 1288), (575, 1267), (576, 1035), (577, 1020), (577, 1088), (577, 1272), (577, 1296), (577, 1267), (578, 852), (579, 1071), (580, 889), (581, 1322), (582, 864), (583, 1323), (584, 1254), (584, 948), (584, 1203), (585, 1075), (586, 1208), (587, 855), (588, 1056), (589, 1016), (590, 1016), (591, 1005), (592, 1324), (592, 1081), (592, 1082), (592, 1325), (592, 1326), (592, 1180), (592, 1181), (592, 1327), (592, 1182), (593, 995), (594, 1173), (595, 857), (596, 1328), (597, 1067), (598, 1045), (599, 1264), (600, 1329), (600, 1136), (600, 1073), (600, 1330), (601, 1267), (602, 1002), (603, 848), (604, 943), (605, 1266), (606, 872), (607, 885), (608, 842), (609, 951), (610, 1018), (611, 1125), (612, 1122), (613, 888), (613, 1309), (613, 1248), (614, 926), (615, 1123), (616, 981), (617, 1119), (618, 1091), (619, 1086), (620, 848), (621, 965), (622, 1331), (623, 1119), (624, 1332), (625, 967), (626, 1065), (627, 1333), (628, 1208), (629, 1035), (630, 1016), (631, 916), (632, 911), (633, 1003), (633, 1006), (634, 1006), (634, 1120), (635, 1334), (636, 953), (636, 892), (636, 1335), (637, 924), (637, 1132), (638, 886), (639, 916), (640, 1074), (641, 936), (642, 1336), (642, 1337), (642, 1334), (642, 1263), (642, 1173), (643, 1242), (644, 912), (645, 1223), (646, 1242), (647, 857), (648, 858), (649, 1331), (649, 923), (650, 1137), (651, 916), (652, 1121), (652, 1003), (653, 1100), (654, 1161), (655, 1242), (656, 1282), (657, 908), (658, 1063), (659, 1122), (659, 1271), (659, 1063), (659, 970), (659, 971), (659, 972), (659, 910), (659, 973), (659, 1338), (660, 835), (661, 843), (662, 1339), (662, 941), (663, 1340), (663, 1229), (663, 1341), (664, 1342), (664, 1187), (665, 843), (666, 1309), (666, 1109), (667, 1316), (668, 1016), (669, 1016), (670, 1065), (671, 1175), (672, 990), (673, 990), (674, 1118), (675, 914), (676, 1145), (676, 1225), (677, 907), (678, 1091), (679, 929), (680, 1343), (680, 1344), (680, 985), (680, 1083), (681, 1145), (681, 1343), (681, 1344), (681, 1126), (681, 1138), (682, 1145), (683, 899), (684, 926), (685, 1345), (686, 1103), (686, 1242), (686, 1345), (687, 1271), (688, 1271), (689, 873), (690, 1346), (690, 852), (690, 1177), (690, 1347), (690, 1012), (690, 1348), (690, 989), (691, 1204), (692, 1324), (692, 1349), (693, 928), (694, 831), (695, 924), (695, 1350), (695, 1246), (695, 1089), (695, 1205), (695, 1247), (695, 969), (695, 1351), (695, 939), (695, 1352), (695, 1253), (696, 1191), (696, 1353), (696, 1310), (696, 1354), (696, 1337), (696, 1193), (696, 1194), (696, 1355), (696, 1356), (697, 881), (698, 982), (699, 982), (700, 1062), (701, 926), (702, 1357), (702, 1310), (703, 1194), (704, 1234), (705, 1358), (706, 1359), (707, 1021), (708, 1359), (709, 997), (710, 840), (711, 889), (712, 1219), (713, 955), (714, 870), (715, 1360), (715, 888), (715, 1246), (715, 1361), (715, 1319), (715, 914), (715, 969), (715, 947), (715, 1362), (715, 939), (715, 1248), (715, 1261), (716, 834), (717, 1149), (718, 1323), (719, 1139), (719, 1264), (719, 941), (720, 1264), (721, 1139), (722, 998), (723, 1359), (723, 1363), (723, 1107), (724, 1273), (725, 1116), (726, 982), (727, 1209), (728, 1150), (729, 948), (729, 1092), (729, 966), (729, 1106), (729, 1364), (729, 996), (729, 1261), (729, 1090), (730, 1086), (731, 1208), (731, 1209), (732, 1207), (733, 1144), (734, 1050), (735, 1129), (736, 858), (736, 1072), (736, 980), (736, 1123), (736, 1185), (736, 1228), (737, 1130), (738, 1032), (739, 1162), (739, 1245), (740, 1140), (740, 1080), (740, 1245), (741, 926), (742, 1119), (743, 939), (744, 1344), (744, 1138), (745, 1343), (746, 985), (746, 1083), (746, 1138), (747, 869), (748, 982), (749, 1056), (750, 1153), (751, 1100), (752, 1313), (753, 943), (754, 1142), (755, 1199), (756, 830), (757, 1161), (758, 1365), (758, 1366), (759, 984), (760, 892), (761, 915), (762, 1144), (763, 906), (763, 1367), (763, 885), (763, 1174), (764, 1346), (764, 1332), (764, 1225), (765, 1297), (766, 1178), (767, 959), (767, 960), (767, 1323), (767, 961), (767, 963), (767, 964), (768, 848), (769, 1214), (770, 916), (771, 1171), (772, 911), (773, 840), (774, 1289), (774, 939), (775, 1368), (775, 939), (776, 887), (776, 939), (777, 939), (778, 1369), (778, 939), (779, 881), (779, 1268), (780, 1091), (781, 853), (782, 843), (783, 1316), (783, 860), (784, 1227), (785, 882), (786, 986), (787, 933), (788, 1088), (788, 1002), (788, 1296), (788, 1370), (788, 1281), (789, 1370), (790, 1077), (791, 1077), (792, 1028), (793, 1207), (793, 1208), (794, 1207), (795, 872), (796, 879), (797, 1365), (797, 1197), (797, 1366), (797, 1216), (797, 897), (797, 900), (797, 901), (798, 1018), (799, 1371), (800, 1338), (801, 1364), (802, 943), (803, 857), (804, 1046), (805, 1344), (806, 851), (807, 945), (808, 1033), (809, 1176), (809, 1155), (809, 989), (810, 1155), (811, 1064), (811, 1095), (811, 1372), (811, 939), (811, 1373), (812, 1163), (812, 941), (812, 875), (812, 1374), (813, 1202), (814, 995), (815, 1340), (815, 1342), (815, 1358), (815, 1375), (815, 1137), (815, 1318), (815, 1302), (815, 1354), (815, 1229), (815, 962), (815, 1188), (815, 1014), (815, 876), (815, 1376), (815, 1377), (815, 1181), (815, 1378), (815, 1328), (815, 1379), (815, 1380), (815, 1233), (815, 1341), (815, 989), (815, 1244), (815, 1085), (816, 982), (817, 1080), (818, 1303), (818, 1322), (818, 1019), (819, 1330), (820, 848), (821, 1153), (821, 1348), (822, 941), (823, 1056), (824, 1000), (825, 1228), (826, 1129), (827, 1094), (828, 1127), (829, 1100)])
	nothing
end

# ╔═╡ 0538d557-454d-498f-9b86-ba285ee7faf3
begin
	# define the bipartite crime network
	G_bip = SimpleGraphFromIterator(crime_edges)

	# project the crime network onto its layers
	G_persons, G_crimes = project(G_bip, layer=:bottom), project(G_bip, layer=:top)
end

# ╔═╡ c17fc916-28ea-45f6-b19d-ec23fea8367d
md"""
We can generate a bipartite configuration model and obtain the validated projections.
"""

# ╔═╡ fde6c0e4-ccf6-4c5f-a465-7baf83b29c1d
begin
	# generate a BiCM from the bipartite crime network
	model_bip = BiCM(G_bip); 
	
	# compute the maximum likelihood parameters
	solve_model!(model_bip); 
	
	# determine the validated projected networks
	G_persons_validated, G_crime_validated = project(model_bip, layer=:bottom), project(model_bip, layer=:top);

	nothing
end


# ╔═╡ 08b8417a-eedb-4b08-a504-58a342f005a0
# check the number of (validated) edges in both networks
@info """
Validated network results:
* person layer: $(round(ne(G_persons_validated) / ne(G_persons)*100, digits=2))% of edges significant
* crime layer:  $(round(ne(G_crime_validated) / ne(G_crimes)*100, digits=2))% of edges significant
"""

# ╔═╡ a4a595c2-7fff-4626-ad2b-88a7f23c07df
md"""
# Performance
Tested against Python "competitor" (which uses Numba, Cython etc.) using the following framework:
* Test system:
  - Intel(R) Core(TM) i7-8700K CPU @ 3.70GHz (6 cores, 12 threads)
  - 64GB DDR4-2133
  - Ubuntu 22.04.4 LTS
* Python config:
  - Python 3.12.4
  - pytest 8.2.2
  - pytest-benchmark 4.0.0
  - nemtropy 3.0.3
* Julia config
  - Julia 1.9.3
  - Benchmarktools 1.5.0
  - MaxEntropyGraphs 0.4.0

**Note:** the size of the graph does not matter for the computation of the parameters, only the number of (or pairs of) unique constraints.
"""

# ╔═╡ 993c4dac-2642-4222-9b93-fa6f8c5a0e6f
md"UBCM:"

# ╔═╡ e943d8da-3e6b-4357-8666-83b10c7ea7ac
md"""
$(Resource("https://i.imgur.com/iSaKGl9.png", :width => 450))

$(Resource("https://i.imgur.com/MA7u4k1.png", :width => 450))
"""

# ╔═╡ 142d9528-48c3-43e1-9a6d-8f8b1363c118
md"""BiCM:

$(Resource("https://i.imgur.com/c2YaC13.png", :width => 700))
"""

# ╔═╡ 5d01233f-46b9-4ec5-83eb-eaf0375bfa76
md"""
# Way ahead
* More optimisations
* More maximum entropy models
* Julia GPU acceleration for some aspects

Suggestions and tips are welcome!

More at [MaxEntropyGraphs.jl Github](https://github.com/B4rtDC/MaxEntropyGraphs.jl)
"""

# ╔═╡ 87de8426-8c54-4583-87f7-51657497e0ab
md"""
Reach out:
- [GitHub](https://github.com/B4rtDC)
- [Royal Military Academy, Brussel, Belgium](https://researchportal.rma.ac.be/en/persons/bart-de-clerck-2)
- [Ghent Univeristy, Ghent, Belgium](https://research.ugent.be/web/person/bart-de-clerck-0/en)
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
MaxEntropyGraphs = "0bc52ce7-e54a-4624-bf8b-683aa79224c9"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
StatsPlots = "f3b207a7-027a-5e70-b257-86293d7955fd"

[compat]
Graphs = "~1.11.1"
MaxEntropyGraphs = "~0.4.0"
Plots = "~1.40.4"
PlutoUI = "~0.7.59"
StatsPlots = "~0.15.7"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "73d333a1457d55f30be5c88d9dc5771bf5ef9bd4"

[[deps.ADTypes]]
git-tree-sha1 = "016833eb52ba2d6bea9fcb50ca295980e728ee24"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "0.2.7"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "9b9b347613394885fd1c8c7729bfc60528faa436"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.4"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "c5aeb516a84459e0318a02507d2261edad97eb75"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.7.1"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "f1dff6729bc61f4d49e140da1af55dcd1ac97b2f"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.5.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a2f1c8c668c8e3cb4cca4e57a8efdb09067bb3fd"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+2"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "SparseInverseSubset", "Statistics", "StructArrays", "SuiteSparse"]
git-tree-sha1 = "227985d885b4dbce5e18a96f9326ea1e836e5a03"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.69.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "71acdbf594aab5bbb2cec89b208c41b4c411e49f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.24.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[deps.CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "9b1ca1aa6ce3f71b3d1840c538a8210a043625eb"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.8.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "4b270d6465eb21ae89b732182c20dc165f8bf9f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.25.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "b1c55339b7c6c350ee89f2c1604299660525b248"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.15.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "6cbbd4d241d7e6579ab354737f4dd95ca43946e1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.1"

[[deps.ConsoleProgressMonitor]]
deps = ["Logging", "ProgressMeter"]
git-tree-sha1 = "3ab7b2136722890b9af903859afcf457fa3059e8"
uuid = "88cd18e8-d9cc-4ea6-8889-5259c0d15c8b"
version = "0.1.2"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "9c405847cc7ecda2dc921ccf18b47ca150d7317e"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.109"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "0653c0a2396a6da5bc4766c43041ef5fd3efbe57"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.11.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "73d1214fec245096717847c62d389a5d2ac86504"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.22.0"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "c154546e322a9c73364e8a60430b0f79b812d320"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "10.2.0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "ec632f177c0d990e64d955ccc1b8c04c485a0950"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.6"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "3e527447a45901ea392fe12120783ad6ec222803"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.6"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "182c478a179b267dd7a741b6f8f4c3e0803795d6"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.6+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "7c82e6a6cd34e9d935e9aa4051b66c6ff3af59ba"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.2+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "334d300809ae0a68ceee3444c6e99ded412bf0b3"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.11.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "950c3717af761bc3ff906c2e8e52bd83390b6ec2"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.14"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be50fe8df3acbffa0274a744f1a99d29c45a57f4"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.1.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"
weakdeps = ["Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "a6adc2dcfe4187c40dc7c2c9d2128e326360e90a"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.32"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "7d703202e65efa1369de1279c162b915e245eed1"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.9"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Preferences", "Printf", "Requires", "Unicode"]
git-tree-sha1 = "389aea28d882a40b5e1747069af71bdbd47a1cae"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "7.2.1"

    [deps.LLVM.extensions]
    BFloat16sExt = "BFloat16s"

    [deps.LLVM.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "88b916503aac4fb7f701bb625cd84ca5dd1677bc"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.29+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "e0b5cd21dc1b44ec6e64f351976f961e6f31d6c4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.3"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LeftChildRightSiblingTrees]]
deps = ["AbstractTrees"]
git-tree-sha1 = "fb6803dafae4a5d62ea5cab204b1e657d9737e7f"
uuid = "1d6d02ad-be62-4b6b-8a6d-2f90e265016e"
version = "0.2.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "c6a36b22d2cca0e1a903f00f600991f97bf5f426"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.4.6"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "80b2833b56d466b3858d565adcd16a4a05f2089b"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.1.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "DataStructures", "ForwardDiff", "JSON", "LinearAlgebra", "MutableArithmetics", "NaNMath", "OrderedCollections", "PrecompileTools", "Printf", "SparseArrays", "SpecialFunctions", "Test", "Unicode"]
git-tree-sha1 = "fffbbdbc10ba66885b7b4c06f4bd2c0efc5813d6"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "1.30.0"

[[deps.MathProgBase]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9abbe463a1e9fc507f12a69e7f29346c2cdc472c"
uuid = "fdba3010-5040-5b88-9595-932c9decdf73"
version = "0.7.8"

[[deps.MaxEntropyGraphs]]
deps = ["Combinatorics", "Dates", "Distributions", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Logging", "MultipleTesting", "NLsolve", "Optimization", "OptimizationNLopt", "OptimizationOptimJL", "PrecompileTools", "Preferences", "Printf", "ReverseDiff", "Revise", "SimpleWeightedGraphs", "SparseArrays", "Zygote"]
git-tree-sha1 = "97bfd5936bcc3c08562fcd7dd93545f3dc9251d8"
uuid = "0bc52ce7-e54a-4624-bf8b-683aa79224c9"
version = "0.4.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.MultipleTesting]]
deps = ["Distributions", "SpecialFunctions", "StatsBase"]
git-tree-sha1 = "1e98f8f732e7035c4333135b75605b74f3462b9b"
uuid = "f8716d33-7c4a-5097-896f-ce0ecbd3ef6b"
version = "0.6.0"

[[deps.MultivariateStats]]
deps = ["Arpack", "Distributions", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "816620e3aac93e5b5359e4fdaf23ca4525b00ddf"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.3"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "898c56fbf8bf71afb0c02146ef26f3a454e88873"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.4.5"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NLopt]]
deps = ["MathOptInterface", "MathProgBase", "NLopt_jll"]
git-tree-sha1 = "5a7e32c569200a8a03c3d55d286254b0321cd262"
uuid = "76087f3c-5699-56af-9a33-bf431cd00edd"
version = "0.6.5"

[[deps.NLopt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9b1f15a08f9d00cdb2761dcfa6f453f5d0d6f973"
uuid = "079eb43e-fd8e-5478-9966-2cf3e3edb778"
version = "2.7.1+0"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded64ff6d4fdd1cb68dfcbb818c69e144a5b2e4c"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.16"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "e64b4f5ea6b7389f6f046d13d4896a8f9c1ba71e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a028ee3cb5641cccc4c24e90c36b0a4f7707bdf5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "d9b79c4eed437421ac4285148fcadf42e0700e89"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.9.4"
weakdeps = ["MathOptInterface"]

    [deps.Optim.extensions]
    OptimMOIExt = "MathOptInterface"

[[deps.Optimization]]
deps = ["ADTypes", "ArrayInterface", "ConsoleProgressMonitor", "DocStringExtensions", "LinearAlgebra", "Logging", "LoggingExtras", "Pkg", "Printf", "ProgressLogging", "Reexport", "Requires", "SciMLBase", "SparseArrays", "SymbolicIndexingInterface", "TerminalLoggers"]
git-tree-sha1 = "d124973a6dacd4252ec9101e0b30e725afd056ac"
uuid = "7f7a1694-90dd-40f0-9382-eb1efda571ba"
version = "3.20.2"

    [deps.Optimization.extensions]
    OptimizationEnzymeExt = "Enzyme"
    OptimizationFiniteDiffExt = "FiniteDiff"
    OptimizationForwardDiffExt = "ForwardDiff"
    OptimizationMTKExt = "ModelingToolkit"
    OptimizationReverseDiffExt = "ReverseDiff"
    OptimizationSparseDiffExt = ["SparseDiffTools", "Symbolics", "ReverseDiff"]
    OptimizationTrackerExt = "Tracker"
    OptimizationZygoteExt = "Zygote"

    [deps.Optimization.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    FiniteDiff = "6a86dc24-6348-571c-b903-95158fe2bd41"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    ModelingToolkit = "961ee093-0014-501f-94e3-6117800e7a78"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseDiffTools = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.OptimizationNLopt]]
deps = ["NLopt", "Optimization", "Reexport"]
git-tree-sha1 = "dc1b76eae7c47ae77560803587911d4d219af531"
uuid = "4e6fcdb7-1186-4e1f-a706-475e75c168bb"
version = "0.1.8"

[[deps.OptimizationOptimJL]]
deps = ["Optim", "Optimization", "Reexport", "SparseArrays"]
git-tree-sha1 = "bea24fb320d58cb639e3cbc63f8eedde6c667bd3"
uuid = "36348300-93cb-4f02-beb5-3c3902f8871e"
version = "0.1.14"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "6e55c6841ce3411ccb3457ee52fc48cb698d6fb0"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.2.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "442e1e7ac27dd5ff8825c3fa62fbd1e86397974b"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.4"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "80d919dee55b9c50e8d9e2da5eeafff3fe58b539"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.4"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "763a8ceb07833dd51bb9e3bbca372de32c0605ad"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.0"

[[deps.PtrArrays]]
git-tree-sha1 = "f011fbb92c4d401059b2212c05c0601b70f8b759"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "Requires", "SparseArrays", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "27ee1c03e732c488ecce1a25f0d7da9b5d936574"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.3.3"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ReverseDiff]]
deps = ["ChainRulesCore", "DiffResults", "DiffRules", "ForwardDiff", "FunctionWrappers", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "Random", "SpecialFunctions", "StaticArrays", "Statistics"]
git-tree-sha1 = "cc6cd622481ea366bb9067859446a8b01d92b468"
uuid = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
version = "1.15.3"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "12aa2d7593df490c407a3bbd8b86b8b515017f3e"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.14"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d483cd324ce5cf5d61b77930f0bbd6cb61927d21"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.2+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "6aacc5eefe8415f47b3e34214c1d79d2674a0ba2"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.12"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SciMLBase]]
deps = ["ADTypes", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FillArrays", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "Printf", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables", "TruncatedStacktraces"]
git-tree-sha1 = "09324a0ae70c52a45b91b236c62065f78b099c37"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "2.15.2"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBasePartialFunctionsExt = "PartialFunctions"
    SciMLBasePyCallExt = "PyCall"
    SciMLBasePythonCallExt = "PythonCall"
    SciMLBaseRCallExt = "RCall"
    SciMLBaseZygoteExt = "Zygote"

    [deps.SciMLBase.weakdeps]
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"
    PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
    PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
    RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLOperators]]
deps = ["ArrayInterface", "DocStringExtensions", "Lazy", "LinearAlgebra", "Setfield", "SparseArrays", "StaticArraysCore", "Tricks"]
git-tree-sha1 = "51ae235ff058a64815e0a2c34b1db7578a06813d"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.7"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "90b4f68892337554d31cdcdbe19e48989f26c7e6"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.3"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SparseInverseSubset]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "52962839426b75b3021296f7df242e40ecfc0852"
uuid = "dc90abb0-5640-4711-901d-7e5b23a2fada"
version = "0.1.2"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "6e00379a24597be4ae1ee6b2d882e15392040132"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.5"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "NaNMath", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "3b1dcbf62e469a67f6733ae493401e53d92ff543"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.15.7"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "f4dc295e983502292c4c3f951dbb4e985e35b3be"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.18"
weakdeps = ["Adapt", "GPUArraysCore", "SparseArrays", "StaticArrays"]

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.SymbolicIndexingInterface]]
git-tree-sha1 = "be414bfd80c2c91197823890c66ef4b74f5bf5fe"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TerminalLoggers]]
deps = ["LeftChildRightSiblingTrees", "Logging", "Markdown", "Printf", "ProgressLogging", "UUIDs"]
git-tree-sha1 = "f133fab380933d042f6796eda4e130272ba520ca"
uuid = "5d786b92-1e48-4d6f-9151-6b4477ca9bed"
version = "0.1.7"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "d73336d81cafdc277ff45558bb7eaa2b04a8e472"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.10"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "ea3e54c2bdde39062abf5a9758a23735558705e1"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.4.0"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "dd260903fdabea27d9b6021689b3cd5401a57748"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.20.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "52ff2af32e591541550bd753c0da8b9bc92bb9d9"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.7+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "GPUArrays", "GPUArraysCore", "IRTools", "InteractiveUtils", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "PrecompileTools", "Random", "Requires", "SparseArrays", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "19c586905e78a26f7e4e97f81716057bd6b1bc54"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.70"

    [deps.Zygote.extensions]
    ZygoteColorsExt = "Colors"
    ZygoteDistancesExt = "Distances"
    ZygoteTrackerExt = "Tracker"

    [deps.Zygote.weakdeps]
    Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
    Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "27798139afc0a2afa7b1824c206d5e87ea587a00"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.5"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─6810f92f-a328-4a38-9401-ed5f909e6223
# ╟─faadea64-c4e4-4d60-8e1e-8069e90ce473
# ╟─c61d36ad-9577-44f7-bbfd-ebff93571c22
# ╟─0fd958de-27b5-40bf-bcc8-523558022291
# ╟─60e3b179-4f50-45be-a331-1e351512d41e
# ╟─56ce2010-c593-4e53-aa75-30c9eb8246f9
# ╟─93cc0d87-0420-47fd-8f9a-633c93cbc9ef
# ╟─89618fb7-88ab-4eb7-ba27-f397f82e8a4d
# ╟─966eba08-f630-46e0-988e-800d24a70b77
# ╟─a0e57d8c-85d5-4aeb-a537-5354bb3578bf
# ╠═c8086d4f-dae4-429d-9fe8-fbad153949ac
# ╟─8bf54ab7-1005-4e12-becc-9012c80a0d43
# ╠═37a2163c-5c32-4e51-980b-1cd8de386675
# ╟─e389d224-e93f-49e1-8f03-8e1e77dbbd98
# ╠═1af46182-5888-4b58-bc63-681362f794c0
# ╟─00bc5aa2-514b-41be-b31c-d8517bd13481
# ╠═a86d6113-c298-43fe-9396-a7ccd553d1b8
# ╟─21b99047-2a60-4433-9421-d03a8b529664
# ╟─c81c72c6-2b7c-4396-a214-9525b879e6ca
# ╟─6e1b8c79-70fb-47ed-a048-2ddccb4a00f3
# ╟─5428e10b-2f42-4798-ade3-648aad5162cb
# ╠═d3bafba4-7273-4380-b5b9-1defd00eae5f
# ╟─4a281bfa-2390-4dd8-96c2-6c1e89bf10fe
# ╠═751543bd-eeae-416c-b8b1-55dce90302c5
# ╟─d7b31b52-931b-4cbf-81f9-73aa07b5e8bb
# ╠═d2740c1d-be9e-4115-801d-2a7c83d5977b
# ╟─f94f51f6-6f18-4a23-a000-e08aa3ab194a
# ╟─f6fa24cf-c479-4ee9-bbcc-5069761b49e8
# ╟─38fd94bc-2e14-4087-aefd-7fe4835528c7
# ╟─202db463-d177-4210-b02a-df0423985ca6
# ╟─f4bc2242-743c-41da-b48e-57503eaa5dd7
# ╠═0538d557-454d-498f-9b86-ba285ee7faf3
# ╟─c17fc916-28ea-45f6-b19d-ec23fea8367d
# ╠═fde6c0e4-ccf6-4c5f-a465-7baf83b29c1d
# ╟─08b8417a-eedb-4b08-a504-58a342f005a0
# ╟─a4a595c2-7fff-4626-ad2b-88a7f23c07df
# ╟─993c4dac-2642-4222-9b93-fa6f8c5a0e6f
# ╟─e943d8da-3e6b-4357-8666-83b10c7ea7ac
# ╟─142d9528-48c3-43e1-9a6d-8f8b1363c118
# ╟─5d01233f-46b9-4ec5-83eb-eaf0375bfa76
# ╟─87de8426-8c54-4583-87f7-51657497e0ab
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
